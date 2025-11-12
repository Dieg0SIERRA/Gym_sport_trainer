#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QString>

class DatabaseManager : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    // Methods callable from QML
    Q_INVOKABLE bool createUser(const QString &username, const QString &password);
    Q_INVOKABLE bool validateLogin(const QString &username, const QString &password);
    Q_INVOKABLE bool userExists(const QString &username);
    Q_INVOKABLE int getUserId(const QString &username);
    
    // Methods callable from QML - Exercises
    Q_INVOKABLE bool addExercise(int userId, const QString &name, const QString &repetitions, 
                                  int series, double weight, const QString &grip, const QString &notes);
    Q_INVOKABLE QVariantList getExercisesByUser(int userId);
    Q_INVOKABLE bool deleteExercise(int exerciseId);
    Q_INVOKABLE bool updateExercise(int exerciseId, const QString &name, const QString &repetitions, 
                                     int series, double weight, const QString &grip, const QString &notes);

signals:
    // Signals to notify QML - users
    void userCreated(bool success, const QString &message);
    void loginValidated(bool success, const QString &message);
    
    // Signals to notify QML - exercise
    void exerciseAdded(bool success, const QString &message);
    void exerciseDeleted(bool success, const QString &message);
    void exerciseUpdated(bool success, const QString &message);

private:
    QSqlDatabase m_database;

    bool initializeDatabase();
    QString hashPassword(const QString &password) const;
    bool createTables();
};

#endif // DATABASEMANAGER_H
