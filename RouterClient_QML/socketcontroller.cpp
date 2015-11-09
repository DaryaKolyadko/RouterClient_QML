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
    rootObject = engine.rootObjects().first();
    QObject *loginForm = rootObject->findChild<QObject*>("mainLoginForm");
    loginTextInput = loginForm->findChild<QObject*>("loginTextInput");
    passwordTextInput = loginForm->findChild<QObject*>("passwordTextInput");
    hostAddressTextInput = loginForm->findChild<QObject*>("hostAddressTextInput");

    if(!socket.doConnect(hostAddressTextInput->property("text").toString(), 8080))//8080))
        sendErrorMessage(socket.getErrorMessage());
    else {
        init();
    }
  //  greetingLabel->setProperty("text", "Hello, " + (enterNameTextField->property("text")).toString() + "!");
}

void SocketController::init()
{
    QObject *configurationForm = rootObject->findChild<QObject*>("mainConfigurationForm");
    QObject *tabView = configurationForm->findChild<QObject*>("tabView");
    QObject *generalConfigTab = tabView->findChild<QObject*>("generalConfigurationTab");
    configHostAddressTextInput = generalConfigTab->findChild<QObject*>("hostAddressTextInput");
    networkMaskTextInput = generalConfigTab->findChild<QObject*>("networkMaskTextInput");
    macAddressTextInput = generalConfigTab->findChild<QObject*>("macAddressTextInput");

    QObject *tabHello = tabView->findChild<QObject*>("helloTab");
    QObject* enterNameTextField = tabHello->findChild<QObject*>("enterNameTextField");
    QObject* greetingLabel = tabHello->findChild<QObject*>("greetingLabel");

    QObject *wifiConfigTab = tabView->findChild<QObject*>("wifiConfigurationTab");
    ssidTextInput = wifiConfigTab->findChild<QObject*>("ssidTextInput");
    //TODO comboboxes

    QObject *systemInformationTab = tabView->findChild<QObject*>("systemInformationTab");
    modelTextInput = systemInformationTab->findChild<QObject*>("modelTextInput");
    hostNameTextInput = systemInformationTab->findChild<QObject*>("hostNameTextInput");
    serviceCodeTextInput = systemInformationTab->findChild<QObject*>("serviceCodeTextInput");
    workGroupTextInput = systemInformationTab->findChild<QObject*>("workGroupTextInput");


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
