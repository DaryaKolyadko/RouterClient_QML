#ifndef VLANSETTINGSPARSER_H
#define VLANSETTINGSPARSER_H


#include "parser.h"
#include <QDebug>
#include <QString>
#include <QList>
#include <QMap>
#include <QPair>

class VlanSettingsParser: Parser
{
public:
    VlanSettingsParser();
    QMap<int, int> parsePortPvidData(QString data);
    QList<QPair<int, int>> parsePortVlanData(QString data);
    QMap<int, QString> parsePortTaggingData(QString data);

signals:

public slots:
};

#endif // VLANSETTINGSPARSER_H
