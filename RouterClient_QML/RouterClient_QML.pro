TEMPLATE = app

QT += qml quick widgets network

CONFIG += openssl-linked

#LIBS += -L"C:\Program Files (x86)\GnuWin32\lib"
#LIBS += D:/OpenSSL-Win32/lib
#INCLUDEPATH += D:/OpenSSL-Win32/include

SOURCES += main.cpp \
    socketcontroller.cpp \
    mysslsocket.cpp \
    wifidataparser.cpp \
    parser.cpp \
    portstatusdataparser.cpp \
    portstatuscountersparser.cpp

RESOURCES += qml.qrc \
    icons.qrc \
    translations.qrc

#ICON = access_point.png

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    socketcontroller.h \
    mysslsocket.h \
    wifiinfoparseresult.h \
    wifidataparser.h \
    parser.h \
    portstatusdataparser.h \
    portstatusparseresult.h \
    portstatuscountersparser.h \
    portsatuscountparseresult.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    windows_icon.rc

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

RC_FILE = windows_icon.rc

TRANSLATIONS = router_en.ts \
               router_ru.ts
