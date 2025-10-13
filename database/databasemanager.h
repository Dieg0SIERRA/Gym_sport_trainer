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

signals:
    // Signals to notify QML
    void userCreated(bool success, const QString &message);
    void loginValidated(bool success, const QString &message);

private:
    QSqlDatabase m_database;

    bool initializeDatabase();
};

#endif // DATABASEMANAGER_H
