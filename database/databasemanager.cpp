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

    return true;
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
        emit loginValidated(false, "Usuario y contraseña no pueden estar vacíos");
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

QString DatabaseManager::hashPassword(const QString &password) const
{
    // Use SHA-256 to hash the password
    QByteArray passwordData = password.toUtf8();
    QByteArray hash = QCryptographicHash::hash(passwordData, QCryptographicHash::Sha256);
    return QString(hash.toHex());
}
