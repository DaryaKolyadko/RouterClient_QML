#ifndef MYSSLSOCKET_H
#define MYSSLSOCKET_H

#include <QObject>
#include <QSslSocket>
#include <QSslCertificate>
#include <QAbstractSocket>
#include <QDebug>

class MySslSocket : public QObject
{
    Q_OBJECT
private:
    QString host;
    bool wasDisconnected;
    int port;
public:
    explicit MySslSocket(QObject *parent = 0);
    QString getErrorMessage();
    QString writeQueryAndReadAnswer(QString message);
    bool doConnect(QString host, int port);
    bool doConnectToExistingSocket();
    void close();

signals:

public slots:
    void connected();
    void disconnected();
    void bytesWritten(qint64 bytes);
  //  void readyRead();

private:
    QSslSocket *socket;
    QString errorMessage;
};

#endif // MYSSLSOCKET_H
