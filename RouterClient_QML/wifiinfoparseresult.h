#ifndef WIFIINFOPARSERESULT
#define WIFIINFOPARSERESULT

#include <QList>
#include <QStringList>
#include <QMap>

struct WifiInfoParseResult{
    QList<int> connectedIndexes;
    QMap<QString, int> columnIndexes;
    // ssid, mode, channel, rate, signal, bars, security
    QList<QStringList> params;
    QStringList columnNames;
};

#endif // WIFIINFOPARSERESULT
