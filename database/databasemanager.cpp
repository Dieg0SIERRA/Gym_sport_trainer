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


