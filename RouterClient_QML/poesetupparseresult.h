#ifndef POESETUPPARSERESULT
#define POESETUPPARSERESULT

#include <QList>
#include <QStringList>
#include <QMap>

struct PoeSetupParseResult{
    QMap<QString, int> columnIndexes;
    // port, rx_packets_count, rx_bytes_count, error_count,
    // tx_packets_count, tx_bytes_count, collisions
    QList<QStringList> params;
    QStringList columnNames;

    void init()
    {
        columnIndexes["port"] = 0;
        columnIndexes["status"] = 1;
        columnIndexes["delivering_power"] = 2;
        columnIndexes["current_ma"] = 3;
        columnIndexes["power_limit_w"] = 4;
        columnIndexes["priority"] = 5;
    }
};

#endif // POESETUPPARSERESULT

