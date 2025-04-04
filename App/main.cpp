#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "Src/hid_commander.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterSingletonInstance<HID_Commander>("HIDCommander", 1, 0, "HIDCommander", HID_Commander::instance());

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Application", "Main");

    return app.exec();
}
