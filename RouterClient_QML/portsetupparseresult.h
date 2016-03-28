#ifndef PORTSETUPPARSERESULT
#define PORTSETUPPARSERESULT

#include <QList>
#include <QStringList>
#include <QMap>

struct PortSetupParseResult{
    QMap<QString, int> columnIndexes;
    // port, mode, flow_control, priority802,
    // port_base_priority, port_description
    QList<QStringList> params;
    QStringList columnNames;

    void init()
    {
        columnIndexes["port"] = 0;
        columnIndexes["mode"] = 1;
        columnIndexes["flow_control"] = 2;
        columnIndexes["priority802"] = 3;
        columnIndexes["port_base_priority"] = 4;
        columnIndexes["port_description"] = 5;
    }
};

#endif // PORTSETUPPARSERESULT
