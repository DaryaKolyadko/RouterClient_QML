#include "socketcontroller.h"
#include <QVariant>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QDebug>
#include <cstdio>
#include <QUrl>

SocketController::SocketController(QObject *parent) : QObject(parent)
{
    loginTextInput = NULL;
    passwordTextInput = NULL;
    hostAddressTextInput = NULL;
    configHostAddressTextInput = NULL;
    networkMaskTextInput = NULL;
    macAddressTextInput = NULL;
    ssidTextInput = NULL;
    modelTextInput = NULL;
    hostNameTextInput = NULL;
    serviceCodeTextInput = NULL;
    workGroupTextInput = NULL;
}

void SocketController::recieveLoginClick()
{
    init();
    if(!socket.doConnect(hostAddressTextInput->property("text").toString(), 8080))//8080))
        sendErrorMessage(socket.getErrorMessage());
  //  greetingLabel->setProperty("text", "Hello, " + (enterNameTextField->property("text")).toString() + "!");
}

void SocketController::init()
{
    QObject *rootObject = engine.rootObjects().first();

    QObject *loginForm = rootObject->findChild<QObject*>("mainLoginForm");
    QObject *gridLayoutLoginForm = loginForm->findChild<QObject*>("gridLayoutLoginForm");
    loginTextInput = gridLayoutLoginForm->findChild<QObject*>("loginTextInput");
    passwordTextInput = gridLayoutLoginForm->findChild<QObject*>("passwordTextInput");
    hostAddressTextInput = gridLayoutLoginForm->findChild<QObject*>("hostAddressTextInput");

    QObject *configurationForm = rootObject->findChild<QObject*>("mainConfigurationForm");
    QObject *tabView = configurationForm->findChild<QObject*>("tabView");

    QObject *generalConfigTab = tabView->findChild<QObject*>("generalConfigurationTab");
    QObject *firstGridConfigTab = generalConfigTab->findChild<QObject*>("mainConfiguration");
//    QObject *gridLayoutConfigTab = firstGridConfigTab->findChild<QObject*>("mainConfigurationGridLayout");
//    configHostAddressTextInput = gridLayoutConfigTab->findChild<QObject*>("hostAddressTextInput");
//    networkMaskTextInput = gridLayoutConfigTab->findChild<QObject*>("networkMaskTextInput");
//    macAddressTextInput = gridLayoutConfigTab->findChild<QObject*>("macAddressTextInput");

//    QObject *wifiConfigTab = tabView->findChild<QObject*>("wifiConfigurationTab");
//    QObject *firstGridWifiTab = wifiConfigTab->findChild<QObject*>("wifiConfiguration");
//    QObject *first = wifiConfigTab->children().first();
//    QString res = first->property("id").toString();
//    QObject *gridLayoutWifiTab = firstGridWifiTab->findChild<QObject*>("wifiConfigurationGridLayout");
//    ssidTextInput = gridLayoutWifiTab->findChild<QObject*>("ssidTextInput");
//    //TODO comboboxes

//    QObject *systemInformationTab = tabView->findChild<QObject*>("systemInformationTab");
//    QObject *firstGridSysInfoTab = systemInformationTab->findChild<QObject*>("systemInformation");
//    QObject *gridLayoutSysInfoTab = firstGridSysInfoTab->findChild<QObject*>("systemInformationGridLayout");
//    modelTextInput = gridLayoutSysInfoTab->findChild<QObject*>("modelTextInput");
//    hostNameTextInput = gridLayoutSysInfoTab->findChild<QObject*>("hostNameTextInput");
//    serviceCodeTextInput = gridLayoutSysInfoTab->findChild<QObject*>("serviceCodeTextInput");
//    workGroupTextInput = gridLayoutSysInfoTab->findChild<QObject*>("workGroupTextInput");


//        qDebug() << loginTextInput->property("text").toString();
//        qDebug() << passwordTextInput->property("text").toString();
//        qDebug() << hostAddressTextInput->property("text").toString();
//     qDebug() << workGroupTextInput->property("text").toString();
//     qDebug() << ssidTextInput->property("text").toString();
//     qDebug() << macAddressTextInput->property("text").toString();
}

QString SocketController::getInfo(QString message)
{
    return socket.writeQueryAndReadAnswer(message + "\r\n");
}

QString SocketController::getParamInfo(QString paramName)
{
    return socket.writeQueryAndReadAnswer("get " + paramName + "\r\n");
}

int SocketController::permitSetInfo(QString message)
{
    return getInfo(message).toInt();
}

int SocketController::confirmLoginAndPassword(QString login, QString password)
{
    return permitSetInfo("auth "  + login + " " + password);
}

void SocketController::close()
{
    socket.close();
}
