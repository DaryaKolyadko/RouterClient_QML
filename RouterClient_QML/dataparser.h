#ifndef DATAPARSER_H
#define DATAPARSER_H

#include <QDebug>
#include <QString>
#include "wifiinfoparseresult.h"

class DataParser
{
private:
    QString wifiStateStr = "connected";
    QString linuxDivider = "\n";
    QString whitespace = " ";

public:
    DataParser();
    WifiInfoParseResult parseWifiConnectionsInfo(QString data);

signals:

public slots:
};

#endif // DATAPARSER_H
