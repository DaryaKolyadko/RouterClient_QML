#include "sslsocketwrapper.h"
#include <QString>
#include <cstdio>
#include <QSslConfiguration>
#include "socketcontroller.h"

SslSocketWrapper::SslSocketWrapper(QObject *parent) :  QObject(parent)
{
    socket = NULL;
    wasDisconnected = false;
}

QString SslSocketWrapper::getErrorMessage()
{
    return errorMessage;
}

bool SslSocketWrapper::doConnect(QString host, int port)
{
    socket = new QSslSocket(this);
    this->host = host;
    this->port = port;
    connect(socket, SIGNAL(connected()),this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()),this, SLOT(disconnected()));
    connect(socket, SIGNAL(bytesWritten(qint64)),this, SLOT(bytesWritten(qint64)));
    connect(socket, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(socketError(QAbstractSocket::SocketError)));
    connect(socket, SIGNAL(sslErrors(QList<QSslError>)),
            this, SLOT(sslErrors(QList<QSslError>)));

    qDebug() << "connecting...";

    // this is not blocking call
    socket->connectToHostEncrypted(host, port);
    // we need to wait...
    if(!socket->waitForEncrypted()){
        errorMessage = "Ошибка при подключении к хосту: " + socket->errorString();
        qDebug() << "Error: " << errorMessage;
        return false;
    }
    return true;
}

void SslSocketWrapper::socketError(QAbstractSocket::SocketError)
{
    qDebug() << socket->errorString();
}

void SslSocketWrapper::sslErrors(const QList<QSslError> &errors)
{
    foreach (const QSslError &error, errors)
        qDebug() <<"error " + error.errorString() + "\n";
   socket->ignoreSslErrors();
}

bool SslSocketWrapper::doConnectToExistingSocket()
{
    qDebug() << "connecting...";

    // this is not blocking call
   socket->connectToHostEncrypted(host, port);

    // we need to wait...
   if(!socket->waitForEncrypted(30000)){
        errorMessage = QT_TR_NOOP("error_while_connecting") + socket->errorString();
        qDebug() << "Error: " << errorMessage;
        return false;
    }
    return true;
}

void SslSocketWrapper::connected()
{
    qDebug() << "connected...";
}

void SslSocketWrapper::disconnected()
{
    qDebug() << "disconnected...";
}

void SslSocketWrapper::bytesWritten(qint64 bytes)
{
    qDebug() << bytes << " bytes written...";
}

QString SslSocketWrapper::writeQueryAndReadAnswer(QString message)
{
    qDebug() << message;
    message = message + "\r\n";
    socket->write(message.toUtf8().constData());
    socket->waitForReadyRead();
    QString res = QString::fromUtf8(socket->readAll());
    qDebug() << res;
    socket->flush();
    return res;
}

void SslSocketWrapper::write(QString message)
{
    qDebug() << message;
    message = message + "\r\n";
    socket->write(message.toUtf8().constData());
    socket->flush();
}

QString SslSocketWrapper::writeAndRead(QByteArray arr)
{
    qDebug() << arr;
    socket->write(arr);
    socket->flush();
    socket->waitForReadyRead();
    QString res = QString::fromUtf8(socket->readAll());
    qDebug() << res;
    return res;
}

void SslSocketWrapper::close()
{
    socket->close();
    qDebug() << "close socket...";
}
