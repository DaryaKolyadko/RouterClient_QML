#include "mytcpsocket.h"
#include <string>
#include <cstdio>

MyTcpSocket::MyTcpSocket(QObject *parent) :  QObject(parent)
{
    socket = NULL;
    wasDisconnected = false;
}

QString MyTcpSocket::getErrorMessage()
{
    return errorMessage;
}

bool MyTcpSocket::doConnect(QString host, int port)
{
    socket = new QTcpSocket(this);
    this->host = host;
    this->port = port;
    connect(socket, SIGNAL(connected()),this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()),this, SLOT(disconnected()));
    connect(socket, SIGNAL(bytesWritten(qint64)),this, SLOT(bytesWritten(qint64)));
   // connect(socket, SIGNAL(readyRead()),this, SLOT(readyRead()));

    qDebug() << "connecting...";

    // this is not blocking call
    socket->connectToHost(host, port);

    // we need to wait...
    if(!socket->waitForConnected(5000))
    {
        errorMessage = "Ошибка при подключении к хосту: " + socket->errorString();
        qDebug() << "Error: " << errorMessage;
        return false;
    }
    return true;
}

bool MyTcpSocket::doConnectToExistingSocket()
{
    qDebug() << "connecting...";

    // this is not blocking call
    socket->connectToHost(host, port);

    // we need to wait...
    if(!socket->waitForConnected(5000))
    {
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

void MyTcpSocket::connected()
{
    qDebug() << "connected...";
}

void MyTcpSocket::disconnected()
{
    qDebug() << "disconnected...";
}

void MyTcpSocket::bytesWritten(qint64 bytes)
{
    qDebug() << bytes << " bytes written...";
}

// возможно, придется убрать
//void MyTcpSocket::readyRead()
//{
  //  qDebug() << "reading...";

    // read the data from the socket
   // qDebug() << socket->readAll();
//}

QString MyTcpSocket::writeQueryAndReadAnswer(QString message)
{
    qDebug() << message;
    doConnect(host, port);
    message = message + "\r\n";
    socket->write(message.toUtf8().constData());
    socket->waitForReadyRead();
    QString res = socket->readAll();
    socket->close();
    return res;
}

void MyTcpSocket::close()
{
    socket->close();
    qDebug() << "close socket...";
}
