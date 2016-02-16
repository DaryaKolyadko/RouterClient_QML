import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1


Item {
    property int fontCoefficient: resolution.dp(40)
    property int marginVal: 15
    property int heightVal: 150
    property int widthVal: 410

    Dialog {
        id: wifiConnectDialog
        title: qsTr("connect_params")
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        height: heightVal
        width: widthVal

        GridLayout {
            id: dialogLayout
            columns: 2
            anchors.fill: parent
            anchors.margins: marginVal

            Text {
                text: qsTr("network_name")
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
            }

            Text {
                id: networkNameText
                text: ""
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
            }

            Text {
                text: qsTr("wifi_password")
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
            }

            TextField {
                id: wifiPasswordInput
                style: MyTextFieldStyle{id: passwordfield}
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                echoMode: TextInput.Password
            }
        }

        onAccepted: {
            doAction();
        }
    }

    function show(networkName)
    {
        networkNameText.text = networkName;
        wifiConnectDialog.open();
    }

    function doAction()
    {
        // should be overrided
    }

    function getPassword()
    {
        return wifiPasswordInput.text;
    }

    ResolutionController{
        id: resolution
    }
}
