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

    // Creating exercises table
    QString createExercisesTable = R"(
        CREATE TABLE IF NOT EXISTS exercises (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            exercise_name TEXT NOT NULL,
            repetitions TEXT NOT NULL,
            series INTEGER NOT NULL,
            weight REAL NOT NULL,
            grip TEXT NOT NULL,
            notes TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
    )";

    if (!query.exec(createExercisesTable)) {
        qWarning() << "Error during creating exercise table:" << query.lastError().text();
        return false;
    }
    return true;
}

// ========== Functions for exercise actions ==========

bool DatabaseManager::addExercise(int userId, const QString &name, const QString &repetitions,
                                  int series, double weight, const QString &grip, const QString &notes)
{
    if (name.trimmed().isEmpty() || repetitions.trimmed().isEmpty()) {
        emit exerciseAdded(false, "El nombre y repeticiones son obligatorios");
        return false;
    }

    if (series <= 0 || weight < 0) {
        emit exerciseAdded(false, "Series y peso deben ser valores válidos");
        return false;
    }

    // Insert exercise
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
        return false;
    }

    qDebug() << "Ejercicio agregado exitosamente:" << name << "para user_id:" << userId;
    emit exerciseAdded(true, "Ejercicio agregado exitosamente");
    return true;
}

QVariantList DatabaseManager::getExercisesByUser(int userId)
{
    QVariantList exercises;

    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT id, exercise_name, repetitions, series, weight, grip, notes, created_at
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

        exercises.append(exercise);
    }

    qDebug() << "Ejercicios obtenidos:" << exercises.size() << "para user_id:" << userId;
    return exercises;
}

bool DatabaseManager::deleteExercise(int exerciseId)
{
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
