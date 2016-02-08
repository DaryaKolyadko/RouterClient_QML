#include "dataparser.h"
#include <QDebug>

DataParser::DataParser()
{
}

WifiInfoParseResult DataParser::parseWifiConnectionsInfo(QString data)
{
    WifiInfoParseResult result;
    QStringList buffer = data.split(linuxDivider, QString::SkipEmptyParts);
    buffer.removeFirst(); // column names

    for (int i = 0; i < buffer.length(); i++) {
        QStringList strParse = buffer.at(i).split(whitespace, QString::SkipEmptyParts);
        result.device.append(strParse.first());
        strParse.removeFirst();
        result.type.append(strParse.first());
        strParse.removeFirst();
        result.state.append(strParse.first());

        if (strParse.first() == wifiStateStr)
            result.connectedIndex = i;

        strParse.removeFirst();

        if (strParse.length() > 1)
            result.connection.append(strParse.join(whitespace));
        else
            result.connection.append(strParse.first());
    }

    qDebug() << "DEVICE  " << result.device;
    qDebug() << "TYPE" << result.type;
    qDebug() << "STATE " << result.state;
    qDebug() << "CONNECTION " <<result.connection;
    qDebug() << "CONNECTED INDEX " << result.connectedIndex;
    return result;
}
