import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: generalConfigurationTabId
    title: qsTr("Основные настройки")
    property bool userEditingConfiguration: false
    property int bottomMargin: 15// -1
    property int fontCoefficient: 100//-1

    Connections {
        target: socketcontroller
    }

    GridLayout{
        id: mainConfiguration
        columns: 3
        anchors.fill: parent

        Button{
            id: changeConfiguration
            text: userEditingConfiguration ? qsTr("Сохранить настройки") : qsTr("Изменить настройки")
            Layout.columnSpan: 3
            Layout.fillWidth: true
            anchors.bottomMargin: bottomMargin

            onClicked: {
                if(userEditingConfiguration)
                    mainConfigurationGridLayout.enabled = false
                else
                    mainConfigurationGridLayout.enabled = true
                userEditingConfiguration = !userEditingConfiguration
                //TODO
                //set all params that have beeen changed
                // create backup to compare
            }
        }

        GridLayout {
            id: mainConfigurationGridLayout
            columns: 3
            anchors.centerIn: parent
            enabled: false
            Layout.fillWidth: true

            Text{
                id: hostAddressText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                text: qsTr("Адрес хоста:" + bottomMargin.toString())
            }

            TextField {
                id: hostAddressTextInput
                objectName: "hostAddressTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                style: MyTextFieldStyle{id: hostaddrfield}
                anchors.bottomMargin: bottomMargin
                validator: RegExpValidator{
                    regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
                }
            }

            Text{
                id: networkMaskText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                text: qsTr("Маска подсети:")
            }

            TextField {
                id:networkMaskTextInput
                objectName: "networkMaskTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                style: MyTextFieldStyle{id: networkmaskfield}
                validator: RegExpValidator{
                    regExp: /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
                }
            }

            Text{
                id: macAddressText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                text: qsTr("MAC-адрес:")
            }

            TextField {
                id:macAddressTextInput
                objectName: "macAddressTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                anchors.bottomMargin: bottomMargin
                style: MyTextFieldStyle{id: macaddrefield}
                validator: RegExpValidator{
                    regExp: /\b(^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$)\b/
                }
            }
        }
    }
}
