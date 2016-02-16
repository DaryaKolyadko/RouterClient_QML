#include "mysslsocket.h"
#include <QString>
#include <cstdio>
#include <QSslConfiguration>
#include "socketcontroller.h"

MySslSocket::MySslSocket(QObject *parent) :  QObject(parent)
{
    socket = NULL;
    wasDisconnected = false;
}

QString MySslSocket::getErrorMessage()
{
    return errorMessage;
}

bool MySslSocket::doConnect(QString host, int port)
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

void MySslSocket::socketError(QAbstractSocket::SocketError)
{
    qDebug() << socket->errorString();
}

void MySslSocket::sslErrors(const QList<QSslError> &errors)
{
    foreach (const QSslError &error, errors)
        qDebug() <<"error " + error.errorString() + "\n";
   socket->ignoreSslErrors();
}

bool MySslSocket::doConnectToExistingSocket()
{
    qDebug() << "connecting...";

    // this is not blocking call
   socket->connectToHostEncrypted(host, port);

    // we need to wait...
   if(!socket->waitForEncrypted(5000)){
        errorMessage = "Ошибка при подключении к хосту: " + socket->errorString();
        qDebug() << "Error: " << errorMessage;
        return false;
    }
    return true;
}

//qDebug() << message;
//if(socket == NULL)
//    doConnect(host, port);
//else if (!wasDisconnected)
//{
//    disconnect(socket, NULL, this, NULL);
//    wasDisconnected = true;
//}

//if(wasDisconnected)
//    doConnectToExistingSocket();
//message = message + "\r\n";
//socket->write(message.toUtf8().constData());
//socket->waitForReadyRead();
//return socket->readAll();

void MySslSocket::connected()
{
    qDebug() << "connected...";
}

void MySslSocket::disconnected()
{
    qDebug() << "disconnected...";
}

void MySslSocket::bytesWritten(qint64 bytes)
{
    qDebug() << bytes << " bytes written...";
}

// возможно, придется убрать
//void MySslSocket::readyRead()
//{
  //  qDebug() << "reading...";

    // read the data from the socket
   // qDebug() << socket->readAll();
//}

QString MySslSocket::writeQueryAndReadAnswer(QString message)
{
    qDebug() << message;
    doConnect(host, port);
//    // try
//    if(!doConnect(host, port))
//        SocketController::sendErrorMessage(socket->errorString());
    message = message + "\r\n";
    socket->write(message.toUtf8().constData());
    socket->waitForReadyRead();
    QString res = QString::fromUtf8(socket->readAll());
    qDebug() << res;
    socket->close();
    return res;
}

void MySslSocket::close()
{
    socket->close();
    qDebug() << "close socket...";
}
