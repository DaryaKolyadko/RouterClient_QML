#ifndef WIFIDATAPARSER_H
#define WIFIDATAPARSER_H

#include <QDebug>
#include <QString>
#include <QList>
#include "wifiinfoparseresult.h"
#include "parser.h"

class WifiDataParser : Parser
{
private:
    QString connectMark = "*";
    QString mbits = "Mbit/s";
    QList<int> findAllConnectedIndexes(QStringList list);
    void pushToParamsList(WifiInfoParseResult& res, QStringList list, int count);
    int combineRateStr(QStringList& list);
    void combineSsid(QStringList& list, int beginIndex, int ssidLength);
    void deleteConnectMark(QStringList& list);

public:
    WifiDataParser();
    WifiInfoParseResult parseWifiConnectionsInfo(QString data);

signals:

public slots:
};

#endif // WIFIDATAPARSER_H
