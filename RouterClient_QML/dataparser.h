#ifndef DATAPARSER_H
#define DATAPARSER_H

#include <QDebug>
#include <QString>
#include <QList>
#include "wifiinfoparseresult.h"

class DataParser
{
private:
    QString linuxDivider = "\n";
    QString whitespace = " ";
    QString connectMark = "*";
    QString mbits = "Mbit/s";
    QList<int> findAllConnectedIndexes(QStringList list);
    void pushToParamsList(WifiInfoParseResult& res, QStringList list, int count);
    int combineRateStr(QStringList& list);
    void combineSsid(QStringList& list, int beginIndex, int ssidLength);
    void deleteConnectMark(QStringList& list);

public:
    DataParser();
    WifiInfoParseResult parseWifiConnectionsInfo(QString data);

signals:

public slots:
};

#endif // DATAPARSER_H
