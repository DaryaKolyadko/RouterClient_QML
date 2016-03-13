#ifndef PORTSATUSCOUNTPARSERESUT
#define PORTSATUSCOUNTPARSERESUT

#include <QList>
#include <QStringList>
#include <QMap>

struct PortStatusCountParseResult{
    QMap<QString, int> columnIndexes;
    // port, rx_packets_count, rx_bytes_count, error_count,
    // tx_packets_count, tx_bytes_count, collisions
    QList<QStringList> params;
    QStringList columnNames;

    void init()
    {
        columnIndexes["port"] = 0;
        columnIndexes["rx_packets_count"] = 1;
        columnIndexes["rx_bytes_count"] = 2;
        columnIndexes["error_count"] = 3;
        columnIndexes["tx_packets_count"] = 4;
        columnIndexes["tx_bytes_count"] = 5;
        columnIndexes["collisions"] = 6;
    }
};

#endif // PORTSATUSCOUNTPARSERESUT
