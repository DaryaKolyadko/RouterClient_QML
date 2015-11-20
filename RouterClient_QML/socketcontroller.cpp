#include "socketcontroller.h"
#include <QVariant>
#include <QQmlComponent>
#include <QMetaObject>
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

    if(!socket.doConnect(hostAddressTextInput->property("text").toString(), 8080))
        sendErrorMessage(socket.getErrorMessage());
    else
    {
        init();
        getValuesFromServer();
    }
}

void SocketController::init()
{
    QObject *configurationForm = rootObject->findChild<QObject*>("mainConfigurationForm");
    QObject *generalConfigTab = configurationForm->findChild<QObject*>("generalConfigurationTab");

//    QVariant returnedValue
//    QMetaObject::invokeMethod(generalConfigTab, "getNetworkMask", Q_RETURN_ARG(QVariant, returnedValue));
//    qDebug() << returnedValue.toString();

    configHostAddressTextInput = generalConfigTab->findChild<QObject*>("hostAddressTextInput");
    networkMaskTextInput = generalConfigTab->findChild<QObject*>("networkMaskTextInput");
    macAddressTextInput = generalConfigTab->findChild<QObject*>("macAddressTextInput");

    QObject *wifiConfigTab = configurationForm->findChild<QObject*>("wifiConfigurationTab");
    ssidTextInput = wifiConfigTab->findChild<QObject*>("ssidTextInput");
    //TODO comboboxes

    QObject *systemInformationTab = configurationForm->findChild<QObject*>("systemInformationTab");
    modelTextInput = systemInformationTab->findChild<QObject*>("modelTextInput");
    hostNameTextInput = systemInformationTab->findChild<QObject*>("hostNameTextInput");
    serviceCodeTextInput = systemInformationTab->findChild<QObject*>("serviceCodeTextInput");
    workGroupTextInput = systemInformationTab->findChild<QObject*>("workGroupTextInput");

//     qDebug() << loginTextInput->property("text").toString();
//     qDebug() << passwordTextInput->property("text").toString();
//     qDebug() << hostAddressTextInput->property("text").toString();
//     qDebug() << workGroupTextInput->property("text").toString();
}

QString SocketController::getInfo(QString message)
{
    return socket.writeQueryAndReadAnswer(message);
}

QString SocketController::getParamInfo(QString paramName)
{
    return socket.writeQueryAndReadAnswer("get" + paramName);
}

int SocketController::setInfo(QString message)
{
    return socket.writeQueryAndReadAnswer(message).toInt();
}

int SocketController::setParamInfo(QString paramName, QString paramValue)
{
    return socket.writeQueryAndReadAnswer("set"  + paramName + " " + paramValue).toInt();
}

//int SocketController::permitSetInfo(QString message)
//{
//    return socket.writeQueryAndReadAnswer(message).toInt();
//}

//int SocketController::permitSetParamInfo(QString paramName, QString paramValue)
//{
//    return socket.writeQueryAndReadAnswer("permit set "  + paramName + " " + paramValue).toInt();
//}

int SocketController::confirmLoginAndPassword(QString login, QString password)
{
    return socket.writeQueryAndReadAnswer("auth "  + login + " " + password).toInt();
}

void SocketController::close()
{
    //socket.close();
}

void SocketController::getValuesFromServer()
{
    configHostAddressTextInput->setProperty("text", hostAddressTextInput->property("text").toString());
    networkMaskTextInput->setProperty("text", getParamInfo("NetworkMask"));
    macAddressTextInput->setProperty("text", getParamInfo("MacAddress"));

    ssidTextInput->setProperty("text", getParamInfo("Ssid"));
    //frequencyRange
    //wifiStatus

    modelTextInput->setProperty("text", getParamInfo("Model"));
    hostNameTextInput->setProperty("text", getParamInfo("HostName"));
    serviceCodeTextInput->setProperty("text", getParamInfo("ServiceCode"));
    workGroupTextInput->setProperty("text", getParamInfo("WorkGroup"));
}
