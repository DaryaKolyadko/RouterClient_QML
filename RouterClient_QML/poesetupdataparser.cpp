#include "poesetupdataparser.h"

PoeSetupDataParser::PoeSetupDataParser()
{
}

PoeSetupParseResult PoeSetupDataParser::parsePoeSetupData(QString data)
{
    PoeSetupParseResult result;
    result.init();
    QStringList buffer = data.split(linuxDivider, QString::SkipEmptyParts);
    int columnsCount = result.columnIndexes.keys().length();
    QStringList buff;

    for (int i = 0; i < columnsCount; i++)
        result.params.append(buff);

    for (int i = 0; i < buffer.length(); i++) {
        QStringList strParse = buffer.at(i).split(whitespace, QString::SkipEmptyParts);

        if (strParse.length() == columnsCount)
            pushToParamsList(result, strParse, columnsCount);
    }

    qDebug() << result.params;
    return result;
}

void PoeSetupDataParser::pushToParamsList(PoeSetupParseResult& res, QStringList list, int count)
{
    for (int j = 0; j < count; j++)
    {
        res.params[j].append(list.at(j));
    }
}
