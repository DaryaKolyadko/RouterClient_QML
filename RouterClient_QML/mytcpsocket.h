#ifndef MYTCPSOCKET_H
#define MYTCPSOCKET_H

#include <QObject>
#include <QSslSocket>
#include <QAbstractSocket>
#include <QDebug>

class MyTcpSocket : public QObject
{
    Q_OBJECT
private:
    QString host;
    bool wasDisconnected;
    int port;
public:
    explicit MyTcpSocket(QObject *parent = 0);
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

#endif // MYTCPSOCKET_H
