#include "mytcpsocket.h"
#include <string>
#include <cstdio>

MyTcpSocket::MyTcpSocket(QObject *parent) :  QObject(parent)
{
}

QString MyTcpSocket::getErrorMessage()
{
    return errorMessage;
}

bool MyTcpSocket::doConnect(QString host, int port)
{
    socket = new QTcpSocket(this);

    connect(socket, SIGNAL(connected()),this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()),this, SLOT(disconnected()));
    connect(socket, SIGNAL(bytesWritten(qint64)),this, SLOT(bytesWritten(qint64)));
   // connect(socket, SIGNAL(readyRead()),this, SLOT(readyRead()));

    qDebug() << "connecting...";

    // this is not blocking call
    socket->connectToHost(host, port);//("google.com", 80); 173.194.112.104

    // we need to wait...
    if(!socket->waitForConnected(5000))
    {
        errorMessage = "Ошибка при подключении к хосту: " + socket->errorString();
        qDebug() << "Error: " << errorMessage;
        return false;
    }
    return true;
}

void MyTcpSocket::connected()
{
    qDebug() << "connected...";

    // отправка логина, пароля, адреса хоста
    // получение ответа
    //socket->write("HEAD / HTTP/1.0\r\n\r\n\r\n\r\n");
    //qDebug() << "lalka" + writeQueryAndReadAnswer("HEAD / HTTP/1.0\r\n\r\n\r\n\r\n");
    // if(
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
    socket->write(message.toUtf8().constData());
    socket->waitForReadyRead();
    return socket->readAll();
}

void MyTcpSocket::close()
{
    socket->close();
    qDebug() << "close socket...";
}
