#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QCryptographicHash>
#include <QDebug>
#include <QStandardPaths>
#include <QDir>

DatabaseManager::DatabaseManager(QObject *parent)
    : QObject(parent)
{
    initializeDatabase();
}

DatabaseManager::~DatabaseManager()
{
    if (m_database.isOpen()) {
        m_database.close();
    }
}

bool DatabaseManager::initializeDatabase()
{
    // Getting path to store database
    // C:/Users/my_user/AppData/Roaming/ExerciseTracker/Exercise Tracker/exercise_tracker.db
    QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

    QDir dir;
    if (!dir.exists(dbPath)) {
        dir.mkpath(dbPath);
    }

    dbPath += "/exercise_tracker.db";

    // Config SQLite database
    m_database = QSqlDatabase::addDatabase("QSQLITE");
    m_database.setDatabaseName(dbPath);

    if (!m_database.open()) {
        qWarning() << "Error al abrir la base de datos:" << m_database.lastError().text();
        return false;
    }

    qDebug() << "Database successfully opened at: " << dbPath;

    // Create tables if they don't exist
    return createTables();
}

bool DatabaseManager::createUser(const QString &username, const QString &password)
{
    if (username.trimmed().isEmpty() || password.isEmpty()) {
        emit userCreated(false, "Username and password cannot be empty.");
        return false;
    }

    if (username.length() < 5) {
        emit userCreated(false, "The user must have at least 5 characters.");
        return false;
    }

    if (userExists(username)) {
        emit userCreated(false, "The user already exists.");
        return false;
    }
    
    // Hashear the password entered
    QString hashedPassword = hashPassword(password);

    // Adding new user
    QSqlQuery query(m_database);
    query.prepare("INSERT INTO users (username, password_hash) VALUES (:username, :password_hash)");
    query.bindValue(":username", username);
    query.bindValue(":password_hash", hashedPassword);

    if (!query.exec()) {
        qWarning() << "Error creating user:" << query.lastError().text();
        emit userCreated(false, "Error creating user in the database");
        return false;
    }

    qDebug() << "User successfully created:" << username;
    emit userCreated(true, "User successfully created");
    return true;
}

bool DatabaseManager::validateLogin(const QString &username, const QString &password)
{
    // Validar entrada
    if (username.trimmed().isEmpty() || password.isEmpty()) {
        emit loginValidated(false, "Username and password cannot be left empty");
        return false;
    }

    // Hashear the password entered
    QString hashedPassword = hashPassword(password);

    QSqlQuery query(m_database);
    query.prepare("SELECT id FROM users WHERE username = :username AND password_hash = :password_hash");
    query.bindValue(":username", username);
    query.bindValue(":password_hash", hashedPassword);

    if (!query.exec()) {
        qWarning() << "Error validating login:" << query.lastError().text();
        emit loginValidated(false, "Error validating login");
        return false;
    }

    if (query.next()) {
        qDebug() << "Successful login for user:" << username;
        emit loginValidated(true, "Successful login");
        return true;
    }

    emit loginValidated(false, "Incorrect username or password");
    return false;
}

bool DatabaseManager::userExists(const QString &username)
{
    QSqlQuery query(m_database);
    query.prepare("SELECT COUNT(*) FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (!query.exec()) {
        qWarning() << "Error verifying user:" << query.lastError().text();
        return false;
    }

    if (query.next()) {
        int count = query.value(0).toInt();
        return count > 0;
    }

    return false;
}

int DatabaseManager::getUserId(const QString &username)
{
    QSqlQuery query(m_database);
    query.prepare("SELECT id FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (!query.exec()) {
        qWarning() << "Error to get user ID:" << query.lastError().text();
        return -1;
    }

    if (query.next()) {
        return query.value(0).toInt();
    }
    return -1;
}

QString DatabaseManager::hashPassword(const QString &password) const
{
    // Use SHA-256 to hash the password
    QByteArray passwordData = password.toUtf8();
    QByteArray hash = QCryptographicHash::hash(passwordData, QCryptographicHash::Sha256);
    return QString(hash.toHex());
}

bool DatabaseManager::createTables()
{
    QSqlQuery query(m_database);

    // Create table for the users
    QString createUsersTable = R"(
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password_hash TEXT NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    )";

    if (!query.exec(createUsersTable)) {
        qWarning() << "Error creating table users:" << query.lastError().text();
        return false;
    }

    qDebug() << "'users' table successfully verified/created";

    // Creating exercises table with template/variation support
    QString createExercisesTable = R"(
        CREATE TABLE IF NOT EXISTS exercises (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            exercise_name TEXT NOT NULL,
            parent_exercise_id INTEGER,
            is_template BOOLEAN DEFAULT 0,
            repetitions TEXT,
            series INTEGER,
            weight REAL,
            grip TEXT,
            notes TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            FOREIGN KEY (parent_exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
        )
    )";

    if (!query.exec(createExercisesTable)) {
        qWarning() << "Error during creating exercise table:" << query.lastError().text();
        return false;
    }

    // Creating Seance table
    QString createSeancesTable = R"(
        CREATE TABLE IF NOT EXISTS seances (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            seance_name TEXT NOT NULL,
            exercise_list TEXT NOT NULL,
            warm_up TEXT NOT NULL,
            notes TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
    )";

    if (!query.exec(createSeancesTable)) {
        qWarning() << "Error during creating seance table:" << query.lastError().text();
        return false;
    }

    // Creating calendar notes table
    QString createCalendarNotesTable = R"(
        CREATE TABLE IF NOT EXISTS calendar_notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            note_date TEXT NOT NULL,
            note_text TEXT NOT NULL,
            note_color TEXT NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            UNIQUE(user_id, note_date)
        )
    )";

    if (!query.exec(createCalendarNotesTable)) {
        qWarning() << "Error during creating calendar notes table:" << query.lastError().text();
        return false;
    }

    qDebug() << "Tabla 'calendar_notes' verificada/creada exitosamente";
    
    return true;
}

// ========== Functions for exercise actions ==========

bool DatabaseManager::addExercise(int userId, const QString &name, const QString &repetitions,
                                  int series, double weight, const QString &grip, const QString &notes)
{
    if (name.trimmed().isEmpty() || repetitions.trimmed().isEmpty()) {
        emit exerciseAdded(false, "El nombre y repeticiones son obligatorios");
        return -1;
    }

    if (series <= 0 || weight < 0) {
        emit exerciseAdded(false, "Series y peso deben ser valores válidos");
        return -1;
    }

    QSqlQuery query(m_database);
    query.prepare(R"(
        INSERT INTO exercises (user_id, exercise_name, repetitions, series, weight, grip, notes)
        VALUES (:user_id, :name, :reps, :series, :weight, :grip, :notes)
    )");

    query.bindValue(":user_id", userId);
    query.bindValue(":name", name);
    query.bindValue(":reps", repetitions);
    query.bindValue(":series", series);
    query.bindValue(":weight", weight);
    query.bindValue(":grip", grip);
    query.bindValue(":notes", notes);

    if (!query.exec()) {
        qWarning() << "Error al agregar ejercicio:" << query.lastError().text();
        emit exerciseAdded(false, "Error al guardar el ejercicio");
        return -1;
    }

    int newExerciseId = query.lastInsertId().toInt();

    qDebug() << "Ejercicio agregado exitosamente:" << name
             << "para user_id:" << userId
             << "con ID:" << newExerciseId;

    emit exerciseAdded(true, "Ejercicio agregado exitosamente");

    return newExerciseId;
}

QVariantList DatabaseManager::getExercisesByUser(int userId)
{
    QVariantList exercises;

    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT id, exercise_name, repetitions, series, weight, grip, notes, created_at,
               parent_exercise_id, is_template
        FROM exercises
        WHERE user_id = :user_id
        ORDER BY created_at DESC
    )");
    query.bindValue(":user_id", userId);

    if (!query.exec()) {
        qWarning() << "Error al obtener ejercicios:" << query.lastError().text();
        return exercises;
    }

    while (query.next()) {
        QVariantMap exercise;
        exercise["id"] = query.value(0).toInt();
        exercise["name"] = query.value(1).toString();
        exercise["repetitions"] = query.value(2).toString();
        exercise["series"] = query.value(3).toInt();
        exercise["weight"] = query.value(4).toDouble();
        exercise["grip"] = query.value(5).toString();
        exercise["notes"] = query.value(6).toString();
        exercise["created_at"] = query.value(7).toString();
        exercise["parent_id"] = query.value(8).isNull() ? -1 : query.value(8).toInt();
        exercise["is_template"] = query.value(9).toBool();

        exercises.append(exercise);
    }

    qDebug() << "Ejercicios obtenidos:" << exercises.size() << "para user_id:" << userId;
    return exercises;
}

bool DatabaseManager::deleteExercise(int exerciseId)
{
    // Check if this is a template with variations
    QSqlQuery checkQuery(m_database);
    checkQuery.prepare("SELECT COUNT(*) FROM exercises WHERE parent_exercise_id = :id");
    checkQuery.bindValue(":id", exerciseId);

    if (checkQuery.exec() && checkQuery.next()) {
        int variationCount = checkQuery.value(0).toInt();
        if (variationCount > 0) {
            qDebug() << "Deleting template with" << variationCount << "variations (cascade delete)";
        }
    }

    // Delete exercise (CASCADE will automatically delete variations if it's a template)
    QSqlQuery query(m_database);
    query.prepare("DELETE FROM exercises WHERE id = :id");
    query.bindValue(":id", exerciseId);

    if (!query.exec()) {
        qWarning() << "Error al eliminar ejercicio:" << query.lastError().text();
        emit exerciseDeleted(false, "Error al eliminar el ejercicio");
        return false;
    }

    if (query.numRowsAffected() > 0) {
        qDebug() << "Ejercicio eliminado exitosamente, ID:" << exerciseId;
        emit exerciseDeleted(true, "Ejercicio eliminado exitosamente");
        return true;
    }

    emit exerciseDeleted(false, "Ejercicio no encontrado");
    return false;
}

bool DatabaseManager::updateExercise(int exerciseId, const QString &name, const QString &repetitions,
                                     int series, double weight, const QString &grip, const QString &notes)
{

    if (name.trimmed().isEmpty() || repetitions.trimmed().isEmpty()) {
        emit exerciseUpdated(false, "El nombre y repeticiones son obligatorios");
        return false;
    }

    if (series <= 0 || weight < 0) {
        emit exerciseUpdated(false, "Series y peso deben ser valores válidos");
        return false;
    }

    // update exercise
    QSqlQuery query(m_database);
    query.prepare(R"(
        UPDATE exercises
        SET exercise_name = :name, repetitions = :reps, series = :series,
            weight = :weight, grip = :grip, notes = :notes
        WHERE id = :id
    )");

    query.bindValue(":name", name);
    query.bindValue(":reps", repetitions);
    query.bindValue(":series", series);
    query.bindValue(":weight", weight);
    query.bindValue(":grip", grip);
    query.bindValue(":notes", notes);
    query.bindValue(":id", exerciseId);

    if (!query.exec()) {
        qWarning() << "Error al actualizar ejercicio:" << query.lastError().text();
        emit exerciseUpdated(false, "Error al actualizar el ejercicio");
        return false;
    }

    if (query.numRowsAffected() > 0) {
        qDebug() << "Ejercicio actualizado exitosamente, ID:" << exerciseId;
        emit exerciseUpdated(true, "Ejercicio actualizado exitosamente");
        return true;
    }

    emit exerciseUpdated(false, "Ejercicio no encontrado");
    return false;
}

// ========== Functions for Calendar Notes ==========

bool DatabaseManager::saveCalendarNote(int userId, const QString &date,
                                       const QString &text, const QString &color)
{
    if (date.trimmed().isEmpty() || text.trimmed().isEmpty() || color.trimmed().isEmpty()) {
        emit calendarNoteSaved(false, "Date, text and color are mandatory");
        return false;
    }

    QSqlQuery query(m_database);

    // Try updating first, if it exists
    query.prepare(R"(
        INSERT INTO calendar_notes (user_id, note_date, note_text, note_color, updated_at)
        VALUES (:user_id, :date, :text, :color, CURRENT_TIMESTAMP)
        ON CONFLICT(user_id, note_date)
        DO UPDATE SET
            note_text = :text,
            note_color = :color,
            updated_at = CURRENT_TIMESTAMP
    )");

    query.bindValue(":user_id", userId);
    query.bindValue(":date", date);
    query.bindValue(":text", text);
    query.bindValue(":color", color);

    if (!query.exec()) {
        qWarning() << "Error during saving calendar note:" << query.lastError().text();
        emit calendarNoteSaved(false, "Error during saving calendar note");
        return false;
    }

    qDebug() << "Calendar nota saved successfully:" << date << "for user_id:" << userId;
    emit calendarNoteSaved(true, "calendar nota saved successfully");
    return true;
}

QVariantMap DatabaseManager::getCalendarNotesByUser(int userId)
{
    QVariantMap notes;

    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT note_date, note_text, note_color
        FROM calendar_notes
        WHERE user_id = :user_id
        ORDER BY note_date ASC
    )");
    query.bindValue(":user_id", userId);

    if (!query.exec()) {
        qWarning() << "Error when getting the calendar notes:" << query.lastError().text();
        return notes;
    }

    while (query.next()) {
        QString date = query.value(0).toString();
        QVariantMap noteData;
        noteData["text"] = query.value(1).toString();
        noteData["color"] = query.value(2).toString();

        notes[date] = noteData;
    }

    qDebug() << "Calendar notes obtained :" << notes.size() << "for user_id:" << userId;
    return notes;
}

bool DatabaseManager::deleteCalendarNote(int userId, const QString &date)
{
    QSqlQuery query(m_database);
    query.prepare("DELETE FROM calendar_notes WHERE user_id = :user_id AND note_date = :date");
    query.bindValue(":user_id", userId);
    query.bindValue(":date", date);

    if (!query.exec()) {
        qWarning() << "Error when removing calendar note:" << query.lastError().text();
        emit calendarNoteDeleted(false, "Error when removing calendar note");
        return false;
    }

    if (query.numRowsAffected() > 0) {
        qDebug() << "Calendar note removed successfully, date:" << date;
        emit calendarNoteDeleted(true, "calendar note removed successfully");
        return true;
    }

    emit calendarNoteDeleted(false, "Calendar note no found");
    return false;
}

// ========== Functions for seance actions ==========

bool DatabaseManager::addSeance(int userId, const QString &name, const QString &exercisesList, const QString &warmUp, const QString &notes)
{
    if (name.trimmed().isEmpty() || exercisesList.trimmed().isEmpty()) {
        emit SeanceAdded(false, "The name and list of exercises are mandatory.");
        return false;
    }

    if (warmUp.trimmed().isEmpty()) {
        emit SeanceAdded(false, "The warm-up type is invalid.");
        return false;
    }

    // Insert Seance
    QSqlQuery query(m_database);
    query.prepare(R"(
        INSERT INTO seances (user_id, seance_name, exercise_list, warm_up, notes)
        VALUES (:user_id, :name, :exercisesList, :warmUp, :notes)
    )");

    query.bindValue(":user_id", userId);
    query.bindValue(":name", name);
    query.bindValue(":exercisesList", exercisesList);
    query.bindValue(":warmUp", warmUp);
    query.bindValue(":notes", notes);

    if (!query.exec()) {
        qWarning() << "Error to add seance:" << query.lastError().text();
        emit SeanceAdded(false, "Error to add seance");
        return false;
    }

    qDebug() << "Seance successfully added:" << name << "for user_id:" << userId;
    emit SeanceAdded(true, "Seance successfully added");
    return true;
}

QVariantList DatabaseManager::getSeanceByUser(int userId)
{
    QVariantList seances;

    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT id, seance_name, exercise_list, warm_up, notes, created_at
        FROM seances
        WHERE user_id = :user_id
        ORDER BY created_at DESC
    )");
    query.bindValue(":user_id", userId);

    if (!query.exec()) {
        qWarning() << "Error to get seance :" << query.lastError().text();
        return seances;
    }

    while (query.next()) {
        QVariantMap seance;
        seance["id"] = query.value(0).toInt();
        seance["name"] = query.value(1).toString();
        
        QString exerciseIds = query.value(2).toString();
        seance["exerciselist"] = getExercisesByIds(exerciseIds);  // Convert IDs to full exercise objects
        
        seance["warmup"] = query.value(3).toString();
        seance["notes"] = query.value(4).toString();
        seance["created_at"] = query.value(5).toString();

        seances.append(seance);
    }

    qDebug() << "Obtained seance:" << seances.size() << "for user_id:" << userId;
    return seances;
}

QVariantList DatabaseManager::getExercisesByIds(const QString &exerciseIds)
{
    QVariantList exercises;
    
    if (exerciseIds.trimmed().isEmpty()) {
        return exercises;
    }
    
    QStringList ids = exerciseIds.split(",", Qt::SkipEmptyParts);
    
    for (const QString &id : ids) {
        QString trimmedId = id.trimmed();
        if (trimmedId.isEmpty()) continue;
        
        QSqlQuery query(m_database);
        query.prepare("SELECT id, exercise_name, repetitions, series, weight, grip, notes FROM exercises WHERE id = :id");
        query.bindValue(":id", trimmedId.toInt());
        
        if (query.exec() && query.next()) {
            QVariantMap exercise;
            exercise["id"] = query.value(0).toInt();
            exercise["nombre"] = query.value(1).toString();
            exercise["repeticiones"] = query.value(2).toString();
            exercise["series"] = query.value(3).toInt();
            exercise["peso"] = query.value(4).toDouble();
            exercise["grip"] = query.value(5).toString();
            exercise["notas"] = query.value(6).toString();
            
            exercises.append(exercise);
        }
    }
    
    qDebug() << "Obtained exercises:" << exercises.size() << "from IDs:" << exerciseIds;
    return exercises;
}

bool DatabaseManager::deleteSeance(int seanceId)
{
    QSqlQuery query(m_database);
    query.prepare("DELETE FROM seances WHERE id = :id");
    query.bindValue(":id", seanceId);

    if (!query.exec()) {
        qWarning() << "Error to remove seance :" << query.lastError().text();
        emit SeanceDeleted(false, "Error to remove seance");
        return false;
    }

    if (query.numRowsAffected() > 0) {
        qDebug() << "Seance successfully removed, ID:" << seanceId;
        emit SeanceDeleted(true, "Seance successfully removed");
        return true;
    }

    emit SeanceDeleted(false, "seance not found");
    return false;
}

bool DatabaseManager::updateSeance(int seanceId, const QString &name, const QString &exercisesList, const QString &warmUp, const QString &notes)
{

    if (name.trimmed().isEmpty() || exercisesList.trimmed().isEmpty()) {
        emit SeanceUpdated(false, "The name and list of exercises are mandatory.");
        return false;
    }

    if (warmUp.trimmed().isEmpty()) {
        emit SeanceUpdated(false, "The warm-up type is invalid.");
        return false;
    }

    // update seance
    QSqlQuery query(m_database);
    query.prepare(R"(
        UPDATE seances
        SET seance_name = :name, exercise_list = :exercisesList, warm_up = :warmUp, notes = :notes
        WHERE id = :id
    )");

    query.bindValue(":id", seanceId);
    query.bindValue(":name", name);
    query.bindValue(":exercisesList", exercisesList);
    query.bindValue(":warmUp", warmUp);
    query.bindValue(":notes", notes);

    if (!query.exec()) {
        qWarning() << "Error to update seance:" << query.lastError().text();
        emit SeanceUpdated(false, "Error to update seance");
        return false;
    }

    if (query.numRowsAffected() > 0) {
        qDebug() << "Seance successfully update:" << name << "for user_id:" << seanceId;
        emit SeanceUpdated(true, "Seance successfully update");
        return true;
    }

    emit SeanceUpdated(false, "Seance not found");
    return false;
}
