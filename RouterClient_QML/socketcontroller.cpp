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
#include <QPair>
#include "wifidataparser.h"
#include "wifiinfoparseresult.h"
#include "portstatusdataparser.h"
#include "portstatusparseresult.h"
#include "portstatuscountersparser.h"
#include "portsatuscountparseresult.h"
#include "portsetupdataparser.h"
#include "portsetupparseresult.h"
#include "poesetupdataparser.h"
#include "poesetupparseresult.h"
#include "vlansettingsparser.h"

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
}

void SocketController::recieveLoginClick()
{
    init();
    //    getPortSetupList();
    //    getPortStatusCountersList();
    //    getPortStatusList();
    //    getInfoAboutWifiConnections();
    //    getPoeSetupList();
    //    getPortTrunkSetup();
    //    getVlanSettings();
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
    if(!socket.doConnect(hostAddressTextInput->property("text").toString(), 10014))
        sendErrorMessage(socket.getErrorMessage());
}

void SocketController::init()
{
    QObject *configurationForm = rootObject->findChild<QObject*>("mainConfigurationForm");
    QObject *generalConfigTab = configurationForm->findChild<QObject*>("generalConfigurationTab");
    QObject *generalConfigSubtab = generalConfigTab->findChild<QObject*>("generalConfigurationSubtab");

    configHostAddressTextInput = generalConfigSubtab->findChild<QObject*>("hostAddressTextInput");
    networkMaskTextInput = generalConfigSubtab->findChild<QObject*>("networkMaskTextInput");
    macAddressTextInput = generalConfigSubtab->findChild<QObject*>("macAddressTextInput");
    modelTextInput = generalConfigSubtab->findChild<QObject*>("modelTextInput");
    swVersionTextInput = generalConfigSubtab->findChild<QObject*>("swVersionTextInput");
    managementVlanModel = generalConfigSubtab->findChild<QObject*>("managementVlanListModel");
    managementVlanCount = managementVlanModel->property("count" ).toInt();
    managementVlanComboBox = generalConfigSubtab->findChild<QObject*>("managementVlanComboBox");
    broadcastStormModel = generalConfigSubtab->findChild<QObject*>("broadcastStormListModel");
    broadcastStormNameList = generalConfigSubtab->findChild<QObject*>("broadcastStormList");
    broadcastStormCount = broadcastStormModel->property("count" ).toInt();
    broadcastStormComboBox = generalConfigSubtab->findChild<QObject*>("broadcastStormComboBox");
    gatewayTextInput = generalConfigSubtab->findChild<QObject*>("gatewayTextInput");
    systemDescriptionTextInput = generalConfigSubtab->findChild<QObject*>("systemDescriptionTextInput");
    generalConfigBackup = generalConfigSubtab->findChild<QObject*>("localBackup");

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

    QObject* availableWifiTab = wifiTab->findChild<QObject*>("availableWifiTab");
    wifiConnectButton = availableWifiTab->findChild<QObject*>("connectToWifiButton");
    availableWifiSubtab = availableWifiTab->findChild<QObject*>("availableWifiSubtab");
    wifiConnectionsModel = availableWifiSubtab->findChild<QObject*>("wifiConnectionsModel");
    wifiTableView = availableWifiSubtab->findChild<QObject*>("wifiTableView");

    QObject* miscConfigurationTab = configurationForm->findChild<QObject*>("miscConfigurationTab");
    QObject* accountSettingsSubtab = miscConfigurationTab->findChild<QObject*>("accountSettingsSubtab");
    accountSettingsLoginTextInput = accountSettingsSubtab->findChild<QObject*>("accountSettingsLoginTextInput");

    QObject* portsTab = configurationForm->findChild<QObject*>("portsTab");
    QObject* portStatusTab = portsTab->findChild<QObject*>("portStatusTab");
    QObject* portStatusSubtab = portStatusTab->findChild<QObject*>("portStatusSubtab");
    portStatusModel = portStatusSubtab->findChild<QObject*>("portStatusModel");

    QObject* portStatusCountersTab = portsTab->findChild<QObject*>("portStatusCountersTab");
    portStatusCountersSubtab = portStatusCountersTab->findChild<QObject*>("portStatusCountersSubtab");
    portStatusCountersModel = portStatusCountersSubtab->findChild<QObject*>("portStatusCountersModel");

    QObject* portTrunkSetupSubtab = portsTab->findChild<QObject*>("portTrunkSetupSubtab");
    portTrunkStatusComboBox = portTrunkSetupSubtab->findChild<QObject*>("portTrunkStatusComboBox");
    portTrunkStatusModel = portTrunkSetupSubtab->findChild<QObject*>("portTrunkStatusListModel");
    portTrunkStatusNameList = portTrunkSetupSubtab->findChild<QObject*>("portTrunkStatusList");
    portTrunkStatusCount = portTrunkStatusModel->property("count").toInt();
    portTrunkConfigBackup = portTrunkSetupSubtab->findChild<QObject*>("localBackup");

    QObject* portSetupTab = portsTab->findChild<QObject*>("portSetupTab");
    QObject* portSetupSubtab = portSetupTab->findChild<QObject*>("portSetupSubtab");
    portSetupModel = portSetupSubtab->findChild<QObject*>("portSetupModel");
    portSetupModelCount = portSetupModel->property("count").toInt();
    portSetupModeNameList = portSetupSubtab->findChild<QObject*>("modeList");
    portSetupModeCount = portSetupModeNameList->property("count").toInt();
    portSetupFlowControlNameList = portSetupSubtab->findChild<QObject*>("flowControlList");
    portSetupFlowControlCount = portSetupFlowControlNameList->property("count").toInt();
    priority802NameList = portSetupSubtab->findChild<QObject*>("priority802List");
    priority802Count = priority802NameList->property("count").toInt();
    portBasePriorityNameList = portSetupSubtab->findChild<QObject*>("portBasePriorityList");
    portBasePriorityCount = portBasePriorityNameList->property("count").toInt();

    QObject* poeTab = configurationForm->findChild<QObject*>("poeTab");
    QObject* poeSubtab = poeTab->findChild<QObject*>("poeSubtab");
    poeSetupModel = poeSubtab->findChild<QObject*>("poeSetupModel");
    poeSetupStatusNameList = poeSubtab->findChild<QObject*>("statusList");
    poeSetupStatusCount = poeSetupStatusNameList->property("count").toInt();
    poeSetupPriorityNameList = poeSubtab->findChild<QObject*>("priorityList");
    poeSetupPriorityCount = poeSetupPriorityNameList->property("count").toInt();

    QObject* vlanTab = configurationForm->findChild<QObject*>("vlanSetupTab");
    vlanTabId = vlanTab->findChild<QObject*>("vlanTabId");
    vlanTypeComboBox = vlanTab->findChild<QObject*>("vlanTypeCombobox");
    vlanTypeList = vlanTab->findChild<QObject*>("vlanTypeList");
    vlanTypeListModel = vlanTab->findChild<QObject*>("vlanTypeListModel");
    vlanTypeCount = vlanTypeListModel->property("count").toInt();
    vlanSubtab = vlanTab->findChild<QObject*>("vlanSetupSubtab");
    vlanBackup  = vlanSubtab->findChild<QObject*>("localBackup");
    vlanCurrentModel = vlanSubtab->findChild<QObject*>("currentVlanModel");
    QObject* vlanSettings = vlanSubtab->findChild<QObject*>("vlanSettings");
    portRepeater = vlanSettings->findChild<QObject*>("portRepeater");
    portTaggingStatusList = vlanSettings->findChild<QObject*>("taggingStatusList");
    portTaggingStatusCount = portTaggingStatusList->property("count").toInt();

    //    portCount = 8;//getParamInfo("PortCount");
    //    portRepeater->setProperty("model", portCount);

    //    QString vlanType = "portBased";//getParamInfo("VlanType");

    //    if(vlanType != "noVlan")
    //    {
    //        portCount = 8;//getParamInfo("PortCount");
    //        vlanBackup  = vlanSubtab->findChild<QObject*>("localBackup");
    //        vlanCurrentModel = vlanSubtab->findChild<QObject*>("currentVlanModel");
    //        QVariant retValue;
    //        QMetaObject::invokeMethod(vlanCurrentModel, "init",
    //                                  Q_RETURN_ARG(QVariant, retValue),
    //                                  Q_ARG(QVariant, portCount),
    //                                  Q_ARG(QVariant, vlanCount));


    //        if (vlanType == "portBased")
    //        {
    //            QObject* vlanSettings = vlanSubtab->findChild<QObject*>("vlanSettings");
    //            vlanSettings->setProperty("visible", true);
    //            portRepeater = vlanSettings->findChild<QObject*>("portRepeater");
    //            portRepeater->setProperty("model", portCount);
    //        }

    //        QMetaObject::invokeMethod(vlanCurrentModel, "addPortVlanEnabled",
    //                                  Q_RETURN_ARG(QVariant, retValue),
    //                                  Q_ARG(QVariant, 3),
    //                                  Q_ARG(QVariant, 2));
    //    }
    //==================
    //getVlanSettings();
    //======

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
    //    configHostAddressTextInput->setProperty("text", hostAddressTextInput->property("text").toString());
    //    networkMaskTextInput->setProperty("text", getParamInfo("NetworkMask"));
    //    macAddressTextInput->setProperty("text", getParamInfo("MacAddress"));
    //    modelTextInput->setProperty("text", getParamInfo("Model"));
    //    swVersionTextInput->setProperty("text", getParamInfo("SwVersion"));
    //    managementVlanServerValue = getParamInfo("ManagementVlan");
    //    managementVlanComboBox->setProperty("currentIndex",
    //                                        findIndexByValue(managementVlanModel, managementVlanCount,
    //                                                         managementVlanServerValue));
    //    broadcastStormServerValue = getParamInfo("BroadcastStormControl");
    //    broadcastStormComboBox->setProperty("currentIndex",
    //                                        findIndexByValue(broadcastStormNameList, broadcastStormCount,
    //                                                         broadcastStormServerValue));
    //    gatewayTextInput->setProperty("text", getParamInfo("Gateway"));
    //    systemDescriptionTextInput->setProperty("text", getParamInfo("SystemDescription"));
    getGeneralConfigData();

    //    ssidTextInput->setProperty("text", getParamInfo("Ssid"));
    //    frequencyRangeComboBox->setProperty("currentIndex",
    //                                        findIndexByValue(frequencyRangeModel, frequencyRangeCount, //"2.4"));
    //                                                         getParamInfo("FrequencyRange")));
    //    wifiStatusServerValue = getParamInfo("WifiStatus");
    //    wifiStatusComboBox->setProperty("currentIndex",
    //                                    findIndexByValue(wifiStatusNameList, wifiStatusCount,
    //                                                     wifiStatusServerValue));
    getWifiConfiguration();

    //    modelTextInput->setProperty("text", getParamInfo("Model"));
    //    hostNameTextInput->setProperty("text", getParamInfo("HostName"));
    //    serviceCodeTextInput->setProperty("text", getParamInfo("ServiceCode"));
    //    workGroupTextInput->setProperty("text", getParamInfo("WorkGroup"));
    accountSettingsLoginTextInput->setProperty("text", getLogin());

    getPortTrunkSetup();
    getVlanSettings();

    corporationInfoText->setProperty("text", getParamInfo("CorporationInfo"));
    //    vlanCount = getParamInfo("VlanCount");
    //    vlanRepeater->setProperty("model", 8);  //getParamInfo("VlanCount"));
    //    int retValue;
    //    QMetaObject::invokeMethod(vlanCurrentModel, "init",
    //                              Q_RETURN_ARG(QVariant, retValue),
    //                              Q_ARG(QVariant, vlanCount),
    //            Q_ARG(QVariant, portCount));

    getInfoAboutWifiConnections();
    getPortStatusList();
    getPortStatusCountersList();
    getPortSetupList();
    getPoeSetupList();
}

void SocketController::initBackup()
{
    generalConfigBackup->setProperty("hostAddress", hostAddressTextInput->property("text"));
    generalConfigBackup->setProperty("networkMask", networkMaskTextInput->property("text"));
    generalConfigBackup->setProperty("managementVlan", managementVlanServerValue);
    generalConfigBackup->setProperty("broadcastStorm", broadcastStormServerValue);
    generalConfigBackup->setProperty("gateway", gatewayTextInput->property("text"));
    generalConfigBackup->setProperty("systemDescription", systemDescriptionTextInput->property("text"));
    wifiConfigBackup->setProperty("ssid", ssidTextInput->property("text"));
    wifiConfigBackup->setProperty("frequencyRange", frequencyRangeComboBox->property("currentText"));
    wifiConfigBackup->setProperty("wifiStatus", wifiStatusServerValue);
}

void SocketController::getVlanSettings()
{
    vlanSubtab->setProperty("init", true);
    vlanTabId->setProperty("init", true);
    //QString vlanType =  "portBased";//"802.1q";//
    QString vlanType = getParamInfo("VlanType");

    if(vlanType == emptyString)
        logOutSignal();

    vlanTypeComboBox->setProperty("currentIndex",
                                  findIndexByValue(vlanTypeList, vlanTypeCount,
                                                   vlanType));

    if(vlanType != "noVlan")
    {
        //portCount = 8;
        portCount = getParamInfo("PortCount").toInt();

        QVariant retValue;
        QMetaObject::invokeMethod(vlanCurrentModel, "init",
                                  Q_RETURN_ARG(QVariant, retValue),
                                  Q_ARG(QVariant, portCount),
                                  Q_ARG(QVariant, vlanCount));

        portRepeater->setProperty("model", portCount);

        QMetaObject::invokeMethod(vlanCurrentModel, "deleteAllChecks",
                                  Q_RETURN_ARG(QVariant, retValue));

        VlanSettingsParser* parser = new VlanSettingsParser();


        QString portVlanData = getParamInfo("VlanSettings");
        // QString portVlanData = "1 1\n2 1\n3 1\n1 3\n4 2\n5 2\n6 2\n7 3\n8 3\n";//

         if(portVlanData == emptyString)
             logOutSignal();

        QList<QPair<int, int>> portVlanDataResult = parser->parsePortVlanData(portVlanData);

        for (int i = 0; i < portVlanDataResult.count(); i++)
        {
            QPair<int, int> portVlanPair = portVlanDataResult.at(i);
            QMetaObject::invokeMethod(vlanCurrentModel, "addPortVlanEnabled",
                                      Q_RETURN_ARG(QVariant, retValue),
                                      Q_ARG(QVariant, portVlanPair.first),
                                      Q_ARG(QVariant, portVlanPair.second));
        }

        //QString portPvidData = "1 1\n2 2\n3 3\n4 4\n5 5\n6 6\n7 7\n8 8\n"; //
        QString portPvidData = getParamInfo("PortsPvid");

        if(portPvidData == emptyString)
            logOutSignal();

        QMap<int, int> portPvidDataResult = parser->parsePortPvidData(portPvidData);

        for(int port = 1; port <= portCount; port++)
        {
            QMetaObject::invokeMethod(vlanCurrentModel, "setPortPvid",
                                      Q_RETURN_ARG(QVariant, retValue),
                                      Q_ARG(QVariant, port),
                                      Q_ARG(QVariant, portPvidDataResult[port]));
        }

        if (vlanType == "802.1q")
        {
            //QString portTaggingData = "1 On\n2 Off\n3 On\n4 On\n5 On\n6 On\n7 On\n8 On\n";//
            QString portTaggingData = getParamInfo("PortsTaggingStatus");

            if(portTaggingData == emptyString)
                logOutSignal();

            QMap<int, QString> portTaggingDataResult = parser->parsePortTaggingData(portTaggingData);

            for(int port = 1; port <= portCount; port++)
            {
                QMetaObject::invokeMethod(vlanCurrentModel, "setPortTaggingStatus",
                                          Q_RETURN_ARG(QVariant, retValue),
                                          Q_ARG(QVariant, port),
                                          Q_ARG(QVariant, findIndexByValue(portTaggingStatusList,
                                                                           portTaggingStatusCount,
                                                                           portTaggingDataResult[port])));
            }
        }
    }

    vlanSubtab->setProperty("init", false);
    vlanTabId->setProperty("init", false);
}

void SocketController::getInfoAboutWifiConnections()
{
    QMetaObject::invokeMethod(wifiConnectionsModel, "clear");
    QVariant retValue;
    //QString data = "*  SSID             MODE   CHAN  RATE       SIGNAL  BARS  SECURITY \n   Promwad Devices  Infra  1     54 Mbit/s  100     ▂▄▆█  WPA2     \n   Promwad Guest    Infra  1     54 Mbit/s  100     ▂▄▆█  WPA2     \n   Promwad Test     Infra  1     54 Mbit/s  100     ▂▄▆█  WPA2     \n   AP-lo1-10        Infra  1     54 Mbit/s  65      ▂▄▆_  WPA2     \n";
    //QString data = "DEVICE  TYPE      STATE        CONNECTION \neth0   ethernet      notconnected    Wired Connection 0    \nwlan0   wifi      connected    eduroam    \neth1    ethernet  unavailable  --         \nlo      loopback  unmanaged    --         \n";
    //QString data = "DEVICE  TYPE      STATE        CONNECTION \nwlan0   wifi      connected    eduroam    \neth0    ethernet  unavailable  --         \nlo      loopback  unmanaged    --         \n";
    //QString data = "  SSID             MODE   CHAN  RATE       SIGNAL  BARS  SECURITY  \n    Promwad  Infra  1     54 Mbit/s 100     ▂▄▆█  WPA2     \n   *         Promwad Guest    Infra  1     54 Mbit/s  100     ▂▄▆█  WPA2     \n *  Promwad Test     Infra  1     54 Mbit/s  100     ▂▄▆█  WPA2      \n   AP-lo1-10        Infra  1     54 Mbit/s  65      ▂▄▆_  WPA2";
    QString data = getParamInfo("WifiConnections");

    if(data == emptyString)
        logOutSignal();

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

void SocketController::getPortTrunkSetup()
{
    portTrunkStatusServerValue = getParamInfo("PortTrunkStatus");
    //portTrunkStatusServerValue = "On";
    portTrunkStatusComboBox->setProperty("currentIndex",
                                         findIndexByValue(portTrunkStatusNameList, portTrunkStatusCount,
                                                          portTrunkStatusServerValue));
}

void SocketController::getGeneralConfigData()
{
    configHostAddressTextInput->setProperty("text", hostAddressTextInput->property("text").toString());
    networkMaskTextInput->setProperty("text", getParamInfo("NetworkMask"));
    macAddressTextInput->setProperty("text", getParamInfo("MacAddress"));
    modelTextInput->setProperty("text", getParamInfo("Model"));
    swVersionTextInput->setProperty("text", getParamInfo("SwVersion"));
    managementVlanServerValue = getParamInfo("ManagementVlan");
    managementVlanComboBox->setProperty("currentIndex",
                                        findIndexByValue(managementVlanModel, managementVlanCount,
                                                         managementVlanServerValue));
    broadcastStormServerValue = getParamInfo("BroadcastStormControl");
    broadcastStormComboBox->setProperty("currentIndex",
                                        findIndexByValue(broadcastStormNameList, broadcastStormCount,
                                                         broadcastStormServerValue));
    gatewayTextInput->setProperty("text", getParamInfo("Gateway"));
    systemDescriptionTextInput->setProperty("text", getParamInfo("SystemDescription"));
}

void SocketController::getWifiConfiguration()
{
    ssidTextInput->setProperty("text", getParamInfo("Ssid"));
    frequencyRangeComboBox->setProperty("currentIndex",
                                        findIndexByValue(frequencyRangeModel, frequencyRangeCount, //"2.4"));
                                                         getParamInfo("FrequencyRange")));
    wifiStatusServerValue = getParamInfo("WifiStatus");
    wifiStatusComboBox->setProperty("currentIndex",
                                    findIndexByValue(wifiStatusNameList, wifiStatusCount,
                                                     wifiStatusServerValue));
}

void SocketController::getPortStatusList()
{
    QMetaObject::invokeMethod(portStatusModel, "clear");
    QVariant retValue;
    //QString data = "1         Down              -               -            - \n2         Down              -               -            - \n3         Down              -               -            -   \n4         up              100M               Full            Off \n";
    QString data = getParamInfo("PortStatusList");

    if(data == emptyString)
        logOutSignal();

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

void SocketController::getPortStatusCountersList()
{
    QMetaObject::invokeMethod(portStatusCountersModel, "clear");
    QVariant retValue;
    //QString data = "1        0              0               0            0              0               0 \n2        0              0               0            0              0               0 \n3        0              0               0            0              0               0 \n4         0              0               0            0              0               0  \n5         0              0               0            0              0               0  \n6         0              0               0            0              0               0  \n7         0              0               0            0              0               0  \n8         0              0               0            0              0               0  \n";
    QString data = getParamInfo("PortStatusCountersList");

    if(data == emptyString)
        logOutSignal();

    PortStatusCountersParser* parser = new PortStatusCountersParser();
    PortStatusCountParseResult result;
    result = parser->parsePortStatusCountData(data);
    int portsCount = result.params[0].length();

    for(int i = 0; i < portsCount; i++)
    {
        QMetaObject::invokeMethod(portStatusCountersModel, "addPortStatusCounter",
                                  Q_RETURN_ARG(QVariant, retValue),
                                  Q_ARG(QVariant, result.params[result.columnIndexes["port"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["rx_packets_count"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["rx_bytes_count"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["error_count"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["tx_packets_count"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["tx_bytes_count"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["collisions"]].at(i)));
    }
}

void SocketController::getPortSetupList()
{
    QMetaObject::invokeMethod(portSetupModel, "clear");
    QVariant retValue;
    //QString data = "1        Auto              On               On            Normal              -               \n2        Auto              On               On            Normal              -               \n3        Auto              On               On            Normal              -               \n4        Auto              On               On            Normal              -               \n5        Auto              On               On            Normal              -               \n6        Auto              On               On            Normal              -               \n7        Auto              On               On            Normal              -               \n8        Auto              On               On            Normal              -               \n";
    QString data = getParamInfo("PortSetupDataList");

    if(data == emptyString)
        logOutSignal();

    PortSetupDataParser* parser = new PortSetupDataParser();
    PortSetupParseResult result;
    result = parser->parsePortSetupData(data);
    int portsCount = result.params[0].length();

    for(int i = 0; i < portsCount; i++)
    {
        int modeIndex  = findIndexByValue(portSetupModeNameList,
                                          portSetupModeCount,
                                          result.params[result.columnIndexes["mode"]].at(i));
        int flowControlIndex = findIndexByValue(portSetupFlowControlNameList,
                                                portSetupFlowControlCount,
                                                result.params[result.columnIndexes["flow_control"]].at(i));
        int priority802Index = findIndexByValue(priority802NameList,
                                                priority802Count,
                                                result.params[result.columnIndexes["priority802"]].at(i));
        int portBasePriorityIndex = findIndexByValue(portBasePriorityNameList,
                                                     portBasePriorityCount,
                                                     result.params[result.columnIndexes["port_base_priority"]].at(i));
        QMetaObject::invokeMethod(portSetupModel, "addPortSetupData",
                                  Q_RETURN_ARG(QVariant, retValue),
                                  Q_ARG(QVariant, result.params[result.columnIndexes["port"]].at(i)),
                Q_ARG(QVariant, modeIndex),
                Q_ARG(QVariant, flowControlIndex),
                Q_ARG(QVariant, priority802Index),
                Q_ARG(QVariant, portBasePriorityIndex),
                Q_ARG(QVariant, result.params[result.columnIndexes["port_description"]].at(i)));
    }
}

void SocketController::getPoeSetupList()
{
    QMetaObject::invokeMethod(poeSetupModel, "clear");
    QVariant retValue;
    //QString data = "1        On              0               0            15,4              0               \n2       On              0               0            15,4              0              \n3        On              0               0            15,4              0              \n4       On              0               0            15,4              0              \n5       On              0               0            15,4              0               \n6       On              0               0            15,4              0                \n7       On              0               0            15,4              0               \n8        On              0               0            15,4              0              \n";
    QString data = getParamInfo("PoeSetupDataList");
    PoeSetupDataParser* parser = new PoeSetupDataParser();

    if(data == emptyString)
        logOutSignal();

    PoeSetupParseResult result;
    result = parser->parsePoeSetupData(data);
    int portsCount = result.params[0].length();

    for(int i = 0; i < portsCount; i++)
    {
        int statusIndex  = findIndexByValue(poeSetupStatusNameList,
                                            poeSetupStatusCount,
                                            result.params[result.columnIndexes["status"]].at(i));
        int priorityIndex = findIndexByValue(poeSetupPriorityNameList,
                                             poeSetupPriorityCount,
                                             result.params[result.columnIndexes["priority"]].at(i));
        QMetaObject::invokeMethod(poeSetupModel, "addPoeSetupData",
                                  Q_RETURN_ARG(QVariant, retValue),
                                  Q_ARG(QVariant, result.params[result.columnIndexes["port"]].at(i)),
                Q_ARG(QVariant, statusIndex),
                Q_ARG(QVariant, result.params[result.columnIndexes["delivering_power"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["current_ma"]].at(i)),
                Q_ARG(QVariant, result.params[result.columnIndexes["power_limit_w"]].at(i)),
                Q_ARG(QVariant, priorityIndex));
    }
}

int SocketController::connectToWifi(QString ssid, QString password)
{
    setWifiConnectButtonState(false);
    QString result = getInfo(QString("connectToWifi %1 %2").arg(ssid, password));
    return result.toInt();
}

void SocketController::logOutSignal()
{
    socket.write("logOut");
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

void SocketController::setWifiConnectButtonState(bool state)
{
    wifiConnectButton->setProperty("enabled", state);
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

int SocketController::sendFile(QString fileName)
{
    QByteArray buffer;
    QFile file(fileName);
    qint64 size = file.size();
    QString result;
    QStringList strList = fileName.split("/");
    QString fileNameToSend = strList[strList.size() - 1].replace(" ", "_");

    do{
        result = socket.writeQueryAndReadAnswer("startUpdateSending " + fileNameToSend
                                                + " " + QString::number(size));

        if (result == "")
            return 0;
    }
    while(result.toInt() != SslSocketWrapper::ok);


    int nextBlockSize = size > blockSize ? blockSize : size;

    if(file.open(QIODevice::ReadOnly))
    {
        QDataStream stream(&file);
        stream.setVersion (QDataStream::Qt_4_2) ;

        while(size > 0)
        {
            char *temp = new char[nextBlockSize + 1];
            stream.readRawData(temp, nextBlockSize);
            buffer.append(temp, nextBlockSize);
            delete [] temp;

            if(stream.status() != QDataStream::Ok)
            {
                qDebug() << "Ошибка чтения файла";
            }

            QString res;

            do{
                res = socket.writeAndRead(buffer);

                if(res == "")
                    return 0;
            }
            while(res.toInt() != SslSocketWrapper::ok);

            size -= nextBlockSize;
            nextBlockSize = size > blockSize ? blockSize : size;
            buffer.clear();
        }

        file.close();
    }
    else
    {
        return -1;
    }

    return 1;
}
