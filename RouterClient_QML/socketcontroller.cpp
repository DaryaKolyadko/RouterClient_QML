#include "socketcontroller.h"
#include <QVariant>
#include <QQuickView>
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
    init();
    getValuesFromServer();
    initBackup();
}

void SocketController::initConnection()
{
    rootObject = engine.rootObjects().first();
    QObject *loginForm = rootObject->findChild<QObject*>("mainLoginForm");
    loginTextInput = loginForm->findChild<QObject*>("loginTextInput");
    passwordTextInput = loginForm->findChild<QObject*>("passwordTextInput");
    hostAddressTextInput = loginForm->findChild<QObject*>("hostAddressTextInput");
    if(!socket.doConnect(hostAddressTextInput->property("text").toString(), 8080))
        sendErrorMessage(socket.getErrorMessage());
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
    generalConfigBackup = generalConfigTab->findChild<QObject*>("localBackup");

    QObject *wifiConfigTab = configurationForm->findChild<QObject*>("wifiConfigurationTab");
    ssidTextInput = wifiConfigTab->findChild<QObject*>("ssidTextInput");
    frequencyRangeComboBox = wifiConfigTab->findChild<QObject*>("frequencyRangeComboBox");
    wifiStatusComboBox = wifiConfigTab->findChild<QObject*>("wifiStatusComboBox");
    frequencyRangeModel = wifiConfigTab->findChild<QObject*>("frequencyRangeListModel");
    frequencyRangeCount = frequencyRangeModel->property("count" ).toInt();
    wifiStatusModel = wifiConfigTab->findChild<QObject*>("wifiStatusListModel");
    wifiStatusCount = wifiStatusModel->property("count" ).toInt();
    wifiConfigBackup = wifiConfigTab->findChild<QObject*>("localBackup");

    QObject *systemInformationTab = configurationForm->findChild<QObject*>("systemInformationTab");
    modelTextInput = systemInformationTab->findChild<QObject*>("modelTextInput");
    hostNameTextInput = systemInformationTab->findChild<QObject*>("hostNameTextInput");
    serviceCodeTextInput = systemInformationTab->findChild<QObject*>("serviceCodeTextInput");
    workGroupTextInput = systemInformationTab->findChild<QObject*>("workGroupTextInput");
    systemInfoBackup = systemInformationTab->findChild<QObject*>("localBackup");
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

int SocketController::permitSetInfo(QString message)
{
    return socket.writeQueryAndReadAnswer(message).toInt();
}

int SocketController::permitSetParamInfo(QString paramName, QString paramValue)
{
    return socket.writeQueryAndReadAnswer("permitSet"  + paramName + " " + paramValue).toInt();
}

int SocketController::confirmLoginAndPassword(QString login, QString password)
{
    return socket.writeQueryAndReadAnswer("auth "  + login + " " + password).toInt();
}

void SocketController::close()
{
    socket.close();
}

void SocketController::getValuesFromServer()
{
    configHostAddressTextInput->setProperty("text", hostAddressTextInput->property("text").toString());
    networkMaskTextInput->setProperty("text", getParamInfo("NetworkMask"));
    macAddressTextInput->setProperty("text", getParamInfo("MacAddress"));

    ssidTextInput->setProperty("text", getParamInfo("Ssid"));
    frequencyRangeComboBox->setProperty("currentIndex",
                     findIndexByValue(frequencyRangeModel, frequencyRangeCount, "2.4"));
                                   //getParamInfo("FrequencyRange")));
    wifiStatusComboBox->setProperty("currentIndex",
                     findIndexByValue(wifiStatusModel, wifiStatusCount, "On"));
                                  // getParamInfo("WifiStatus")));
    modelTextInput->setProperty("text", getParamInfo("Model"));
    hostNameTextInput->setProperty("text", getParamInfo("HostName"));
    serviceCodeTextInput->setProperty("text", getParamInfo("ServiceCode"));
    workGroupTextInput->setProperty("text", getParamInfo("WorkGroup"));
}

void SocketController::initBackup()
{
    generalConfigBackup->setProperty("hostAddress", hostAddressTextInput->property("text"));
    generalConfigBackup->setProperty("networkMask", networkMaskTextInput->property("text"));
    systemInfoBackup->setProperty("hostName", hostNameTextInput->property("text"));
    systemInfoBackup->setProperty("workGroup", workGroupTextInput->property("text"));
    wifiConfigBackup->setProperty("ssid", ssidTextInput->property("text"));
    wifiConfigBackup->setProperty("frequencyRange", frequencyRangeComboBox->property("currentText"));
    wifiConfigBackup->setProperty("wifiStatus", wifiStatusComboBox->property("currentText"));
}

int SocketController::findIndexByValue(QObject* model, int countInt, QString value)
{
    QVariant retValue;
    QVariant count = countInt;
    int counter = 0;
    for(QVariant index = 0; index < count; index = counter)
    {
        bool succeeded = QMetaObject::invokeMethod(
            model, "getChild", Q_RETURN_ARG(QVariant, retValue), Q_ARG( QVariant, index ) );
        if (succeeded)
        {
            const QObject *child = qvariant_cast<QObject *>( retValue );
            QString val = child->property("text").toString();
            qDebug() << val;
            if (value.compare(val) == 0)
                return index.toInt();
        }
        counter++;
    }
    return -1;
}
