#ifndef WIFIINFOPARSERESULT
#define WIFIINFOPARSERESULT

struct WifiInfoParseResult{
    int connectedIndex;
    QStringList device;
    QStringList type;
    QStringList state;
    QStringList connection; // network name
};

#endif // WIFIINFOPARSERESULT

