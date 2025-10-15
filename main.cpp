#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "database/DatabaseManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    QCoreApplication::setOrganizationName("ExerciseTracker");
    QCoreApplication::setApplicationName("Exercise Tracker");
	
	// Create DatabaseManager instance
    DatabaseManager dbManager;    

    // Create and configure the QML engine
    QQmlApplicationEngine engine;
    
    // Expose DatabaseManager to the QML context
    engine.rootContext()->setContextProperty("DatabaseManager", &dbManager);
    
    // Cargar el archivo QML principal
    const QUrl url(QStringLiteral("qrc:/GymTracker/Main.qml"));

    QObject::connect(
    	&engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
