#ifndef PORTSTATUSPARSERESULT
#define PORTSTATUSPARSERESULT

#include <QList>
#include <QStringList>
#include <QMap>

struct PortStatusParseResult{
public:
    QMap<QString, int> columnIndexes;
    // port, link, speed, duplex, flow_control
    QList<QStringList> params;

    void init()
    {
        columnIndexes["port"] = 0;
        columnIndexes["link"] = 1;
        columnIndexes["speed"] = 2;
        columnIndexes["duplex"] = 3;
        columnIndexes["flow_control"] = 4;
    }
};


#endif // PORTSTATUSPARSERESULT
