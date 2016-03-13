#include "socketcontroller.h"
#include <QVariant>
#include <QQuickView>
#include <QQmlComponent>
#include <QMetaObject>
#include <QQmlEngine>
#include <QDebug>
#include <cstdio>
#include <QObject>
#include <QUrl>
#include "wifidataparser.h"
#include "wifiinfoparseresult.h"
#include "portstatusdataparser.h"
#include "portstatusparseresult.h"

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
    if(!socket.doConnect(hostAddressTextInput->property("text").toString(), 10012))
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

    QObject *wifiTab = configurationForm->findChild<QObject*>("wifiTab");
    QObject *wifiConfigSubtab = wifiTab->findChild<QObject*>("wifiConfigurationSubtab");
    ssidTextInput = wifiConfigSubtab->findChild<QObject*>("ssidTextInput");
    frequencyRangeComboBox = wifiConfigSubtab->findChild<QObject*>("frequencyRangeComboBox");
    wifiStatusComboBox = wifiConfigSubtab->findChild<QObject*>("wifiStatusComboBox");
    frequencyRangeModel = wifiConfigSubtab->findChild<QObject*>("frequencyRangeListModel");
    frequencyRangeCount = frequencyRangeModel->property("count" ).toInt();
    wifiStatusModel = wifiConfigSubtab->findChild<QObject*>("wifiStatusListModel");
    wifiStatusNameList = wifiConfigSubtab->findChild<QObject*>("wifiStatusList");
    wifiStatusCount = wifiStatusModel->property("count" ).toInt();
    wifiConfigBackup = wifiConfigSubtab->findChild<QObject*>("localBackup");

//    QObject *systemInformationTab = configurationForm->findChild<QObject*>("systemInformationTab");
//    modelTextInput = systemInformationTab->findChild<QObject*>("modelTextInput");
//    hostNameTextInput = systemInformationTab->findChild<QObject*>("hostNameTextInput");
//    serviceCodeTextInput = systemInformationTab->findChild<QObject*>("serviceCodeTextInput");
//    workGroupTextInput = systemInformationTab->findChild<QObject*>("workGroupTextInput");
//    systemInfoBackup = systemInformationTab->findChild<QObject*>("localBackup");

    availableWifiSubtab = wifiTab->findChild<QObject*>("availableWifiSubtab");
    wifiConnectionsModel = availableWifiSubtab->findChild<QObject*>("wifiConnectionsModel");
    wifiTableView = availableWifiSubtab->findChild<QObject*>("wifiTableView");

    QObject* miscConfigurationTab = configurationForm->findChild<QObject*>("miscConfigurationTab");
    QObject* accountSettingsSubtab = miscConfigurationTab->findChild<QObject*>("accountSettingsSubtab");
    accountSettingsLoginTextInput = accountSettingsSubtab->findChild<QObject*>("accountSettingsLoginTextInput");

    QObject* portsTab = configurationForm->findChild<QObject*>("portsTab");
    QObject* portStatusSubtab = portsTab->findChild<QObject*>("portStatusSubtab");
    portStatusModel = portStatusSubtab->findChild<QObject*>("portStatusModel");

    QObject* portStatusCountersSubtab = portsTab->findChild<QObject*>("portStatusCountersSubtab");
    portStatusCountersModel = portStatusCountersSubtab->findChild<QObject*>("portStatusCountersModel");

    QObject* portTrunkSetupSubtab = portsTab->findChild<QObject*>("portTrunkSetupSubtab");
    portTrunkStatusComboBox = portTrunkSetupSubtab->findChild<QObject*>("portTrunkStatusComboBox");
    portTrunkStatusModel = portTrunkSetupSubtab->findChild<QObject*>("portTrunkStatusListModel");
    portTrunkStatusNameList = portTrunkSetupSubtab->findChild<QObject*>("portTrunkStatusList");
    portTrunkStatusCount = portTrunkStatusModel->property("count" ).toInt();
    portTrunkConfigBackup = portTrunkSetupSubtab->findChild<QObject*>("localBackup");

    QObject* corporationInfoTab = configurationForm->findChild<QObject*>("corporationInfoTab");
    corporationInfoText = corporationInfoTab->findChild<QObject*>("corporationInfoText");
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
    QString resultStr = socket.writeQueryAndReadAnswer("set"  + paramName + " " + paramValue);

    if (resultStr.isEmpty())
        return -1;

    return resultStr.toInt();
}

int SocketController::permitSetInfo(QString message)
{
    QString resultStr = socket.writeQueryAndReadAnswer(message);

    if (resultStr.isEmpty())
        return -1;

    return resultStr.toInt();
}

int SocketController::permitSetParamInfo(QString paramName, QString paramValue)
{
    QString resultStr = socket.writeQueryAndReadAnswer("permitSet"  + paramName + " " + paramValue);

    if (resultStr.isEmpty())
        return -1;

    return resultStr.toInt();
}

int SocketController::setNewPassword(QString paramName, QString oldPassword, QString newPassword)
{
    QString resultStr = socket.writeQueryAndReadAnswer("set"  + paramName + " " + oldPassword
                                                       + " " + newPassword);
    if (resultStr.isEmpty())
        return -1;

    return resultStr.toInt();
}

int SocketController::permitSetNewPassword(QString paramName, QString oldPassword, QString newPassword)
{
    QString resultStr = socket.writeQueryAndReadAnswer("permitSet"  + paramName + " " + oldPassword
                                                       + " " + newPassword);
    if (resultStr.isEmpty())
        return -1;

    return resultStr.toInt();
}

int SocketController::confirmLoginAndPassword(QString login, QString password)
{
    return socket.writeQueryAndReadAnswer(QString("auth %1 %2").arg(login, password)).toInt();
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
                     findIndexByValue(frequencyRangeModel, frequencyRangeCount, //"2.4"));
                                   getParamInfo("FrequencyRange")));
    wifiStatusServerValue = getParamInfo("WifiStatus");
    wifiStatusComboBox->setProperty("currentIndex",
                     findIndexByValue(wifiStatusNameList, wifiStatusCount,
                                   wifiStatusServerValue));
//    modelTextInput->setProperty("text", getParamInfo("Model"));
//    hostNameTextInput->setProperty("text", getParamInfo("HostName"));
//    serviceCodeTextInput->setProperty("text", getParamInfo("ServiceCode"));
//    workGroupTextInput->setProperty("text", getParamInfo("WorkGroup"));
    accountSettingsLoginTextInput->setProperty("text", getLogin());

    portTrunkStatusServerValue = getParamInfo("PortTrunkStatus");
    portTrunkStatusComboBox->setProperty("currentIndex",
                     findIndexByValue(portTrunkStatusNameList, portTrunkStatusCount,
                                   portTrunkStatusServerValue));

    corporationInfoText->setProperty("text", getParamInfo("getCorporationInfo"));

    getInfoAboutWifiConnections();
    getPortStatusList();
}

void SocketController::initBackup()
{
    generalConfigBackup->setProperty("hostAddress", hostAddressTextInput->property("text"));
    generalConfigBackup->setProperty("networkMask", networkMaskTextInput->property("text"));
    systemInfoBackup->setProperty("hostName", hostNameTextInput->property("text"));
    systemInfoBackup->setProperty("workGroup", workGroupTextInput->property("text"));
    wifiConfigBackup->setProperty("ssid", ssidTextInput->property("text"));
    wifiConfigBackup->setProperty("frequencyRange", frequencyRangeComboBox->property("currentText"));
    wifiConfigBackup->setProperty("wifiStatus", wifiStatusServerValue);
}

void SocketController::getInfoAboutWifiConnections()
{
    QMetaObject::invokeMethod(wifiConnectionsModel, "clear");
    QVariant retValue;
    //QString data = "*  SSID             MODE   CHAN  RATE       SIGNAL  BARS  SECURITY \n   Promwad Devices  Infra  1     54 Mbit/s  100     ▂▄▆█  WPA2     \n   Promwad Guest    Infra  1     54 Mbit/s  100     ▂▄▆█  WPA2     \n   Promwad Test     Infra  1     54 Mbit/s  100     ▂▄▆█  WPA2     \n   AP-lo1-10        Infra  1     54 Mbit/s  65      ▂▄▆_  WPA2     \n";
    //QString data = "DEVICE  TYPE      STATE        CONNECTION \neth0   ethernet      notconnected    Wired Connection 0    \nwlan0   wifi      connected    eduroam    \neth1    ethernet  unavailable  --         \nlo      loopback  unmanaged    --         \n";
    //QString data = "DEVICE  TYPE      STATE        CONNECTION \nwlan0   wifi      connected    eduroam    \neth0    ethernet  unavailable  --         \nlo      loopback  unmanaged    --         \n";
    //QString data = "  SSID             MODE   CHAN  RATE       SIGNAL  BARS  SECURITY  \n    Promwad  Infra  1     54  100     ▂▄▆█  WPA2     \n   *         Promwad Guest    Infra  1     54 Mbit/s  100     ▂▄▆█  WPA2     \n *  Promwad Test     Infra  1     54 Mbit/s  100     ▂▄▆█  WPA2      \n   AP-lo1-10        Infra  1     54 Mbit/s  65      ▂▄▆_  WPA2";
    QString data = getParamInfo("WifiConnections");
    WifiDataParser* parser = new WifiDataParser();
    WifiInfoParseResult result;
    result = parser->parseWifiConnectionsInfo(data);
    QVariant varParams;
    varParams.setValue<QList<int>>(result.connectedIndexes);
    QMetaObject::invokeMethod(availableWifiSubtab, "addWifiConnectedIndexes",
            Q_RETURN_ARG(QVariant, retValue),
            Q_ARG(QVariant, varParams));
    int networksCount = result.params[0].length();

    for(int i = 0; i < networksCount; i++)
    {
        bool isConnected = result.connectedIndexes.contains(i);
        QMetaObject::invokeMethod(wifiConnectionsModel, "addWifiConnection",
                Q_RETURN_ARG(QVariant, retValue),
                Q_ARG(QVariant, result.params[result.columnIndexes["ssid"]].at(i)),
                Q_ARG(QVariant, isConnected),
                Q_ARG(QVariant, result.params[result.columnIndexes["rate"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["bars"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["security"]].at(i)));
    }
}

void SocketController::getPortStatusList()
{
    QMetaObject::invokeMethod(portStatusModel, "clear");
    QVariant retValue;
    //QString data = "1         Down              -               -            - \n2         Down              -               -            - \n3         Down              -               -            -   \n4         Up              100M               Full            Off \n";
    QString data = getParamInfo("PortStatusList");
    PortStatusDataParser* parser = new PortStatusDataParser();
    PortStatusParseResult result;
    result = parser->parsePortStatusData(data);
    int portsCount = result.params[0].length();

    for(int i = 0; i < portsCount; i++)
    {
        QMetaObject::invokeMethod(portStatusModel, "addPortStatus",
                Q_RETURN_ARG(QVariant, retValue),
                Q_ARG(QVariant, result.params[result.columnIndexes["port"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["link"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["speed"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["duplex"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["flow_control"]].at(i)));
    }
}

int SocketController::connectToWifi(QString ssid, QString password)
{
    QString result = getInfo(QString("connectToWifi %1 %2").arg(ssid, password));
    return result.toInt();
}

void SocketController::logOutSignal()
{
    logOut();
}

int SocketController::findIndexByValue(QObject* model, int countInt, QString value)
{
    QVariant retValue;
    QVariant count = countInt;
    int counter = 0;
    for(QVariant index = 0; index < count; index = counter) {
        bool succeeded = QMetaObject::invokeMethod(
            model, "getChild", Q_RETURN_ARG(QVariant, retValue), Q_ARG( QVariant, index ) );
        if (succeeded) {
            const QObject *child = qvariant_cast<QObject *>( retValue );
            QString val = child->property("text").toString();
            if (value.compare(val) == 0)
                return index.toInt();
        }
        counter++;
    }
    return -1;
}

QString SocketController::getLogin()
{
    return loginTextInput->property("text").toString();
}

void SocketController::rebootSystem()
{
    socket.write("rebootSystem");
}

void SocketController::restoreSystemDefault()
{
    socket.write("restoreSystemDefault");
    rebootSystem();
}
