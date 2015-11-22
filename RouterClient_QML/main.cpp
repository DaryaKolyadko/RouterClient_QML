#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "mytcpsocket.h"
#include "socketcontroller.h"
#include <QIcon>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    //app.setWindowIcon(QIcon(":/icons/images/router.ico"));

   // QQmlApplicationEngine engine;
   // engine.load(QUrl(QStringLiteral("qrc:/MainForm.qml")));

    SocketController socketController;

    //sc.engine = engine;

    QQmlContext* ctx = socketController.engine.rootContext();
    ctx->setContextProperty("socketcontroller", &socketController);
    socketController.engine.load(QUrl(QStringLiteral("qrc:/MainForm.qml")));
    return app.exec();
}
