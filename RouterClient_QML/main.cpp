#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "mysslsocket.h"
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
   // app.setWindowIcon(QIcon(":/images/wi_fi_router.png"));
    app.addLibraryPath("C:\\Program Files (x86)\\GnuWin32\\lib");
    QSslSocket::supportsSsl();
   // QQmlApplicationEngine engine;
   // engine.load(QUrl(QStringLiteral("qrc:/MainForm.qml")));

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
