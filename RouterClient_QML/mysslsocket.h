#ifndef MYSSLSOCKET_H
#define MYSSLSOCKET_H

#include <QObject>
#include <QSslSocket>
#include <QTcpSocket>
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
    void write(QString message);

signals:

public slots:
    void connected();
    void disconnected();
    void bytesWritten(qint64 bytes);
    void socketError(QAbstractSocket::SocketError);
    void sslErrors(const QList<QSslError> &errors);
  //  void readyRead();

private:
    QSslSocket *socket;
   // QTcpSocket *socket;
    QString errorMessage;
};

#endif // MYSSLSOCKET_H
