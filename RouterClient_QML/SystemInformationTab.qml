import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: systemInformationTabId
    title: qsTr("Информация о системе")

    property bool userEditingConfiguration: false
    property int bottomMargin: 15//-1
    property int fontCoefficient: 100//-1

    Connections {
        target: socketworker
    }

    GridLayout{
        id: systemInformation
        columns: 3
        anchors.fill: parent

        Button{
            id: changeSystemInformation
            text: userEditingConfiguration ? qsTr("Сохранить настройки") : qsTr("Изменить настройки")
            Layout.columnSpan: 3
            Layout.fillWidth: true
            anchors.bottomMargin: bottomMargin

            onClicked: {
                if(userEditingConfiguration)
                    systemInformationGridLayout.enabled = false
                else
                    systemInformationGridLayout.enabled = true
                userEditingConfiguration = !userEditingConfiguration
            }
        }

        GridLayout {
            id: systemInformationGridLayout
            columns: 3
            anchors.centerIn: parent
            enabled: false
            Layout.fillWidth: true

            Text{
                id: model
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("Модель:")
            }

            TextField {
                id: modelTextInput
                objectName: "modelTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                text: qsTr("Keenetic Ultra")
                style: MyTextFieldStyle{id: modelfield}
            }

            Text{
                id:serviceCodeRangeText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("Сервисный код:")
            }

            TextField {
                id: serviceCodeTextInput
                objectName: "serviceCodeTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                text: qsTr("607-066-405-847-030")
                style: MyTextFieldStyle{id: servicecodefield}
                validator: RegExpValidator{
                    regExp: /\b(?:(?:[0-9][0-9][0-9]?)-){3}(?:[0-9][0-9][0-9]?)\b/
                }
            }

            Text{
                id:hostNameText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("Имя хоста:")
            }

            TextField {
                id: hostNameTextInput
                objectName: "hostNameTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                text: qsTr("Keenetic_Ultra")
                style: MyTextFieldStyle{id: hostnamefield}
            }

            Text{
                id: workGroupStatusText
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.fillWidth: true
                text: qsTr("Рабочая группа:")
            }

            TextField {
                id: workGroupTextInput
                objectName: "workGroupTextInput"
                font.letterSpacing: 1
                font.pointSize: (parent.parent.height + parent.parent.width)/fontCoefficient
                Layout.columnSpan: 2
                Layout.fillWidth: true
                text: qsTr("Home_1a-6")
                style: MyTextFieldStyle{id: workgroupfield}
            }
        }
    }
}
