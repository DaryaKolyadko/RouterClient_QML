import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    id: appWindow
    objectName: "appWindow"
    visible: true
    minimumWidth: resolution.dp(635) //635
    minimumHeight: resolution.dp(295)//295
    width: minimumWidth
    height: minimumHeight
    title: qsTr("authorization")

    Component.onCompleted: {
        mainConfigurationForm.generalConfigurationTab.visible = true;
    }

    Connections{
        target: socketcontroller
        onLogOut: {
            logOut();
        }
    }

    LoginForm{
        id: mainLoginForm
        objectName: "mainLoginForm"
        anchors.fill: parent
        visible: true

        onVisibleChanged: {
            pageChanged()
        }
    }

    ConfigurationForm {
        id: mainConfigurationForm
        objectName: "mainConfigurationForm"
        property alias mainConfigForm: mainConfigurationForm
        anchors.fill: parent
        visible: false
    }

    Loader { id: pageLoader }

    function pageChanged ()
    {
        if (mainLoginForm.visible) {
            title = qsTr("authorization");
            mainConfigurationForm.visible = false;
            statusBar.visible = false;
        }
        else {
            title = qsTr("configuration");
            mainConfigurationForm.visible = true;
            statusBar.visible = true;
        }
    }

    statusBar: StatusBar {
        id: statusBar
        visible: false
        RowLayout {
            anchors.fill: parent
            Label {
                id: labelStatus
                text: mainLoginForm.login
                Layout.alignment: Qt.AlignLeft
            }

            Button{
                id: logOutButton
                text: qsTr("log_out")
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    socketcontroller.logOutSignal();
                }
            }
        }
    }

    function logOut()
    {
        mainLoginForm.visible = true;
        mainConfigurationForm.redirectToMainPage();
        socketcontroller.close();
       // appWindow.close();
    }

    ResolutionController{
        id: resolution
    }
}
