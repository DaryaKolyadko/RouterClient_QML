#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "mytcpsocket.h"
#include "socketcontroller.h"
#include <QIcon>
#include <QtGui>
#include <QTranslator>
#include <QLocale>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/images/access_point.png"));

   // QQmlApplicationEngine engine;
   // engine.load(QUrl(QStringLiteral("qrc:/MainForm.qml")));

    SocketController socketController;

    //sc.engine = engine;

    QTranslator* qtTranslator = new QTranslator();
 //   qtTranslator.load("router_" + QLocale::system().name().split('_').at(0), ":/translations/");
//    qtTranslator->load("router_ru", "D:\\RouterClient\\RouterClient_QML\\RouterClient_QML");
 //   qApp->installTranslator(qtTranslator);
    //qtTranslator->load("router_en", "D:\\RouterClient\\RouterClient_QML\\RouterClient_QML");
    qtTranslator->load("router_" + QLocale::system().name().split('_').at(0), "D:\\RouterClient\\RouterClient_QML\\RouterClient_QML");
    app.installTranslator(qtTranslator);

    QQmlContext* ctx = socketController.engine.rootContext();
    ctx->setContextProperty("socketcontroller", &socketController);
    socketController.engine.load(QUrl(QStringLiteral("qrc:/MainForm.qml")));
    return app.exec();
}
