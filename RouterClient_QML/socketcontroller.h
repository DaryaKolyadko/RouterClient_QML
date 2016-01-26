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
    QObject *rootObject;
    QObject *loginTextInput;
    QObject *passwordTextInput;
    QObject *hostAddressTextInput;
    QObject *configHostAddressTextInput;
    QObject *networkMaskTextInput;
    QObject *macAddressTextInput;
    QObject *ssidTextInput;
    QObject *frequencyRangeComboBox;
    QObject *wifiStatusComboBox;
    QObject *modelTextInput;
    QObject *hostNameTextInput;
    QObject *serviceCodeTextInput;
    QObject *workGroupTextInput;
    QObject* generalConfigBackup;
    QObject* systemInfoBackup;
    QObject* wifiConfigBackup;
    QObject* wifiStatusModel;
    QObject* wifiStatusNameList;
    QObject* frequencyRangeModel;
    QString wifiStatusServerValue;
    MySslSocket socket;
    void init();
    void getValuesFromServer();
    int findIndexByValue(QObject* model, int count, QString value);

public:
    explicit SocketController(QObject *parent = 0);
    QQmlApplicationEngine engine;

signals:
    void sendErrorMessage(QString message);
    void wifiComboBoxSetText(QString text);

public slots:
    void initConnection();
    void recieveLoginClick();
    void initBackup();
    QString getInfo(QString message);
    QString getParamInfo(QString paramName);
    int permitSetInfo(QString message); // 1 - permitted, 0 - not permitted
    int permitSetParamInfo(QString param, QString info); // 1 - permitted, 0 - not permitted
    int setInfo(QString message); // 1 - ok, 0 - not ok
    int setParamInfo(QString param, QString info); // 1 - ok, 0 - not ok
    int confirmLoginAndPassword(QString login, QString password); // 1 - ok, 0 - not ok
    void close();
};

#endif // SOCKETCONTROLLER_H
