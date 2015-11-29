TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp \
    mytcpsocket.cpp \
    socketcontroller.cpp

RESOURCES += qml.qrc \
    icons.qrc

#ICON = access_point.png

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    mytcpsocket.h \
    socketcontroller.h

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
