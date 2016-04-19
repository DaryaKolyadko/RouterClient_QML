#ifndef SSLSOCKETWRAPPER_H
#define SSLSOCKETWRAPPER_H

#include <QObject>
#include <QSslSocket>
#include <QTcpSocket>
#include <QSslCertificate>
#include <QAbstractSocket>
#include <QDebug>

class SslSocketWrapper : public QObject
{
    Q_OBJECT
private:
    QString host;
    bool wasDisconnected;
    int port;
public:
    explicit SslSocketWrapper(QObject *parent = 0);
    QString getErrorMessage();
    QString writeQueryAndReadAnswer(QString message);
    QString writeAndRead(QByteArray arr);
    bool doConnect(QString host, int port);
    bool doConnectToExistingSocket();
    void close();
    void write(QString message);
    static const int ok = 1;
    static const int notOk = 0;

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

#endif // SSLSOCKETWRAPPER_H
