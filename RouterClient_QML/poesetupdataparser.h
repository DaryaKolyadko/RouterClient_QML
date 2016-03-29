#ifndef POESETUPDATAPARSER_H
#define POESETUPDATAPARSER_H

#include <QDebug>
#include <QString>
#include <QList>
#include "parser.h"
#include "poesetupparseresult.h"

class PoeSetupDataParser: Parser
{
public:
    PoeSetupDataParser();
    PoeSetupParseResult parsePoeSetupData(QString data);
    void pushToParamsList(PoeSetupParseResult& res, QStringList list, int count);

signals:

public slots:
};

#endif // POESETUPDATAPARSER_H
