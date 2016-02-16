#include "dataparser.h"
#include <QDebug>

DataParser::DataParser()
{
}

WifiInfoParseResult DataParser::parseWifiConnectionsInfo(QString data)
{
    WifiInfoParseResult result;
    QStringList buffer = data.split(linuxDivider, QString::SkipEmptyParts);
    result.connectedIndexes = findAllConnectedIndexes(buffer);
    result.columnNames = buffer.first().split(whitespace, QString::SkipEmptyParts);
    deleteConnectMark(result.columnNames);
    int columnsCount = result.columnNames.length();
    QStringList buff;

    for (int i = 0; i < columnsCount; i++)
        result.params.append(buff);

    for (int i = 0; i < columnsCount; i++)
        result.columnIndexes[result.columnNames[i].toLower()] = i;

    buffer.removeFirst(); // remove title line

    for (int i = 0; i < buffer.length(); i++) {
        QStringList strParse = buffer.at(i).split(whitespace, QString::SkipEmptyParts);
        deleteConnectMark(strParse);
        int realRateIndex = combineRateStr(strParse);
        int ssidLength = realRateIndex - result.columnIndexes["rate"] + 1;
        combineSsid(strParse, result.columnIndexes["ssid"],
                ssidLength);

        if (strParse.length() == columnsCount)
            pushToParamsList(result, strParse, columnsCount);
    }

    qDebug() << result.params;
    return result;
}

void DataParser::pushToParamsList(WifiInfoParseResult& res, QStringList list, int count)
{
    for (int j = 0; j < count; j++)
    {
        res.params[j].append(list.at(j));
    }
}

int DataParser::combineRateStr(QStringList &list)
{
    int patternIndex = list.indexOf(mbits);

    if(patternIndex > -1)
    {
        list[patternIndex - 1].append(whitespace).append(list[patternIndex]);
        list.removeAt(patternIndex);
    }

    return patternIndex - 1;
}

void DataParser::combineSsid(QStringList &list, int beginIndex, int ssidLength)
{
    if (ssidLength > 0)
    {
        for (int i = 1; i < ssidLength; i++)
        {
            list[beginIndex].append(whitespace).append(list[beginIndex + 1]);
            list.removeAt(beginIndex + 1);
        }
    }
}

void DataParser::deleteConnectMark(QStringList &list)
{
    int markIndex = list.indexOf(connectMark);

    if(markIndex > -1)
        list.removeAt(markIndex);
}


QList<int> DataParser::findAllConnectedIndexes(QStringList list)
{
    QList<int> indexes;

    for (int i = 0; i < list.length(); i++)
    {
        if(list.at(i).contains(connectMark))
        {
            indexes.append(i - 1); // if connectMark is in the title line => no connect => -1
        }
    }

    return indexes;
}
