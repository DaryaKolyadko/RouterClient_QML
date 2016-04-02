#ifndef SOCKETCONTROLLER_H
#define SOCKETCONTROLLER_H

#include <QObject>
#include <QVariant>
#include <QString>
#include <QQmlApplicationEngine>
#include "mysslsocket.h"

class SocketController : public QObject
{
    Q_OBJECT

private:
    int wifiStatusCount;
    int frequencyRangeCount;
    int portTrunkStatusCount;
    QObject *rootObject;
    QObject *loginTextInput;
    QObject *passwordTextInput;
    QObject *hostAddressTextInput;
    QObject *configHostAddressTextInput;
    QObject *networkMaskTextInput;
    QObject *macAddressTextInput;
    QObject *swVersionTextInput;
    QObject *managementVlanModel;
    int managementVlanCount;
    QObject* managementVlanComboBox;
    QString managementVlanServerValue;
    QObject *broadcastStormComboBox;
    QObject *broadcastStormModel;
    QObject *broadcastStormNameList;
    int broadcastStormCount;
    QString broadcastStormServerValue;
    QObject *gatewayTextInput;
    QObject *systemDescriptionTextInput;
    QObject *portSetupModel;
    int portSetupModelCount;
    QObject *portSetupModeNameList;
    int portSetupModeCount;
    QObject *portSetupFlowControlNameList;
    int portSetupFlowControlCount;
    QObject *priority802NameList;
    int priority802Count;
    QObject *portBasePriorityNameList;
    int portBasePriorityCount;
    QObject *poeSetupModel;
    QObject *poeSetupStatusNameList;
    int poeSetupStatusCount;
    QObject *poeSetupPriorityNameList;
    int poeSetupPriorityCount;
    QObject *ssidTextInput;
    QObject *frequencyRangeComboBox;
    QObject *wifiStatusComboBox;
    QObject *modelTextInput;
    QObject* generalConfigBackup;
    QObject* systemInfoBackup;
    QObject* wifiConfigBackup;
    QObject* wifiStatusModel;
    QObject* wifiStatusNameList;
    QObject* frequencyRangeModel;
    QObject* wifiConnectionsModel;
    QString wifiStatusServerValue;
    QObject* wifiTableView;
    QObject* availableWifiSubtab;
    QObject* accountSettingsLoginTextInput;
    QObject* portStatusModel;
    QObject* portStatusCountersSubtab;
    QObject* portStatusCountersModel;
    QObject* corporationInfoText;
    QObject* portTrunkStatusComboBox;
    QString portTrunkStatusServerValue;
    QObject* portTrunkStatusModel;
    QObject* portTrunkStatusNameList;
    QObject* portTrunkConfigBackup;
    MySslSocket socket;
    void init();
    void getValuesFromServer();
    int findIndexByValue(QObject* model, int count, QString value);

public:
    explicit SocketController(QObject *parent = 0);
    QQmlApplicationEngine engine;
    bool fl = false;

signals:
    void sendErrorMessage(QString message);
    void wifiComboBoxSetText(QString text);
    void logOut();

public slots:
    void initConnection();
    void recieveLoginClick();
    void initBackup();
    void getInfoAboutWifiConnections();
    void getPortStatusList();
    void getPortStatusCountersList();
    void getPortSetupList();
    void getPoeSetupList();
    void getPortTrunkSetup();
    QString getLogin();
    QString getInfo(QString message);
    QString getParamInfo(QString paramName);
    int permitSetInfo(QString message); // 1 - permitted, 0 - not permitted
    int permitSetParamInfo(QString param, QString info); // 1 - permitted, 0 - not permitted
    int setInfo(QString message); // 1 - ok, 0 - not ok
    int setParamInfo(QString param, QString info); // 1 - ok, 0 - not ok
    int confirmLoginAndPassword(QString login, QString password); // 1 - ok, 0 - not ok
    int setNewPassword(QString paramName, QString oldPassword, QString newPassword); // 1 - ok, 0 - not ok
    int permitSetNewPassword(QString paramName, QString oldPassword, QString newPassword);
    void close();
    int connectToWifi(QString ssid, QString password);
    void logOutSignal();
    void rebootSystem();
    void restoreSystemDefault();
};

#endif // SOCKETCONTROLLER_H
