#include "vlansettingsparser.h"

VlanSettingsParser::VlanSettingsParser()
{

}

QMap<int, int> VlanSettingsParser::parsePortPvidData(QString data)
{
    QMap<int, int> result;
    QStringList buffer = data.split(linuxDivider, QString::SkipEmptyParts);

    for (int i = 0; i < buffer.length(); i++) {
        QStringList strParse = buffer.at(i).split(whitespace, QString::SkipEmptyParts);

        if (strParse.length() == 2)
            result.insert(strParse.first().toInt(), strParse.last().toInt());
    }

    qDebug() << result;
    return result;
}

QList<QPair<int, int>> VlanSettingsParser::parsePortVlanData(QString data)
{
    QList<QPair<int, int>> result;
    QStringList buffer = data.split(linuxDivider, QString::SkipEmptyParts);

    for (int i = 0; i < buffer.length(); i++) {
        QStringList strParse = buffer.at(i).split(whitespace, QString::SkipEmptyParts);

        if (strParse.length() == 2)
            result.append(qMakePair(strParse.first().toInt(), strParse.last().toInt()));
    }

    qDebug() << result;
    return result;
}

QMap<int, QString> VlanSettingsParser::parsePortTaggingData(QString data)
{
    QMap<int, QString> result;
    QStringList buffer = data.split(linuxDivider, QString::SkipEmptyParts);

    for (int i = 0; i < buffer.length(); i++) {
        QStringList strParse = buffer.at(i).split(whitespace, QString::SkipEmptyParts);

        if (strParse.length() == 2)
            result.insert(strParse.first().toInt(), strParse.last());
    }

    qDebug() << result;
    return result;
}
