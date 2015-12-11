#include "mysslsocket.h"
#include <string>
#include <cstdio>

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
    //socket = new QTcpSocket(this);
    socket = new QSslSocket(this);
    this->host = host;
    this->port = port;

    QList<QSslCertificate> cert = QSslCertificate::fromPath(QLatin1String("D:\\RouterClient\\RouterClient_QML\\RouterClient_QML\\mycertificate.crt"));
    QSslError error(QSslError::SelfSignedCertificate, cert.at(0));
    QList<QSslError> expectedSslErrors;
    expectedSslErrors.append(error);
    socket->ignoreSslErrors(expectedSslErrors);

    socket->setPrivateKey("D:\\RouterClient\\RouterClient_QML\\RouterClient_QML\\mykey.key", QSsl::Rsa);
    //socket->setLocalCertificate("D:\\RouterClient\\RouterClient_QML\\RouterClient_QML\\mycertificate.crt");
    connect(socket, SIGNAL(connected()),this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()),this, SLOT(disconnected()));
    connect(socket, SIGNAL(bytesWritten(qint64)),this, SLOT(bytesWritten(qint64)));
   // connect(socket, SIGNAL(readyRead()),this, SLOT(readyRead()));

    qDebug() << "connecting...";

    // this is not blocking call
    //socket->connectToHost(host, port);
    socket->connectToHostEncrypted(host, port);
    // we need to wait...
    //if(!socket->waitForConnected(5000))
    if(!socket->waitForEncrypted(5000)){
        errorMessage = "Ошибка при подключении к хосту: " + socket->errorString();
        qDebug() << "Error: " << errorMessage;
        return false;
    }
    return true;
}

bool MySslSocket::doConnectToExistingSocket()
{
    qDebug() << "connecting...";

    // this is not blocking call
    //socket->connectToHost(host, port);
    socket->connectToHostEncrypted(host, port);

    // we need to wait...
    //if(!socket->waitForConnected(5000)){
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
   // doConnect(host, port);
    message = message + "\r\n";
    socket->write(message.toUtf8().constData());
    socket->waitForReadyRead();
    QString res = socket->readAll();
  //  socket->close();
    return res;
}

void MySslSocket::close()
{
    socket->close();
    qDebug() << "close socket...";
}
