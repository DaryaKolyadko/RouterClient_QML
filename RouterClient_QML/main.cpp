#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "sslsocketwrapper.h"
#include "socketcontroller.h"
#include <QIcon>
#include <QtGui>
#include <QTranslator>
#include <QLocale>
#include <QSslSocket>
#include <QtNetwork>

int main(int argc, char *argv[])
{
     QApplication app(argc, argv);

    //QGuiApplication may be resolve "ASSERT: "context" in file
    //opengl\qopenglfunctions.cpp" bug
    // It is QTBUG-42213
    // TEST IT!!!
    //QGuiApplication app(argc, argv);
    //app.addLibraryPath("C:\\Program Files (x86)\\GnuWin32\\lib");

    SocketController socketController;
    QTranslator* qtTranslator = new QTranslator();

    bool result  = qtTranslator->load("router_" + QLocale::system().name().split('_').at(0), ":/");

    if (!result)
        qtTranslator->load("router_en", ":/");

    app.installTranslator(qtTranslator);

    QQmlContext* ctx = socketController.engine.rootContext();
    ctx->setContextProperty("socketcontroller", &socketController);
    socketController.engine.load(QUrl(QStringLiteral("qrc:/MainForm.qml")));
    return app.exec();
}
