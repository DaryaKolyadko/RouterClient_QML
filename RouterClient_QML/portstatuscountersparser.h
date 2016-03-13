#ifndef PORTSTATUSCOUNTERSPARSER_H
#define PORTSTATUSCOUNTERSPARSER_H

#include <QDebug>
#include <QString>
#include <QList>
#include "parser.h"
#include "portsatuscountparseresult.h"

class PortStatusCountersParser: Parser
{
public:
    PortStatusCountersParser();
    PortStatusCountParseResult parsePortStatusCountData(QString data);
    void pushToParamsList(PortStatusCountParseResult& res, QStringList list, int count);
signals:

public slots:
};

#endif // PORTSTATUSCOUNTERSPARSER_H
