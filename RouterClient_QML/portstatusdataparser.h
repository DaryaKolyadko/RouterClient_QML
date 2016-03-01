#ifndef PORTSTATUSDATAPARSER_H
#define PORTSTATUSDATAPARSER_H

#include <QDebug>
#include <QString>
#include <QList>
#include "parser.h"
#include "portstatusparseresult.h"

class PortStatusDataParser: Parser
{
public:
    PortStatusDataParser();
    PortStatusParseResult parsePortStatusData(QString data);
    void pushToParamsList(PortStatusParseResult& res, QStringList list, int count);

signals:

public slots:
};

#endif // PORTSTATUSDATAPARSER_H
