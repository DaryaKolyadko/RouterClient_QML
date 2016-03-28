#ifndef PORTSETUPDATAPARSER_H
#define PORTSETUPDATAPARSER_H

#include <QDebug>
#include <QString>
#include <QList>
#include "parser.h"
#include "portsetupparseresult.h"


class PortSetupDataParser: Parser
{
public:
    PortSetupDataParser();
    PortSetupParseResult parsePortSetupData(QString data);
    void pushToParamsList(PortSetupParseResult& res, QStringList list, int count);

signals:

public slots:
};

#endif // PORTSETUPDATAPARSER_H
