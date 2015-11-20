import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab{
    id: systemInformationTabId
    active: true
    title: qsTr("Информация о системе")

    property bool userEditingConfiguration: false
    property int bottomMargin: 15
    property int fontCoefficient: 100

    Connections {
        target: socketcontroller
    }

//    InfoMessageDialog {
//        id: systemConfigurationMessageDialog
//    }

    GridLayout{
        id: systemInformation
        columns: 3
        anchors.fill: parent

        InfoMessageDialog {
            id: systemConfigurationMessageDialog
        }

        Button{
            id: changeSystemInformation
            text: userEditingConfiguration ? qsTr("Сохранить настройки") : qsTr("Изменить настройки")
            Layout.columnSpan: 3
            Layout.fillWidth: true
            anchors.bottomMargin: bottomMargin

            onClicked: {
                if(userEditingConfiguration)
                {
                    systemInformationGridLayout.enabled = false
                    if(checkAndSetNewParamValue("Model", modelTextInput.text) &&
                            checkAndSetNewParamValue("ServiceCode", serviceCodeTextInput.text) &&
                            checkAndSetNewParamValue("HostName", hostNameTextInput.text) &&
                            checkAndSetNewParamValue("WorkGroup", workGroupTextInput.text)){
                       systemConfigurationMessageDialog.show(qsTr("Все изменения сохранены."));
                    }
                    else return;
                }
                else
                    systemInformationGridLayout.enabled = true;
                userEditingConfiguration = !userEditingConfiguration;
                //TODO
                // create backup to compare
            }

            function checkAndSetNewParamValue(paramName, paramValue)
            {
                var res = socketcontroller.setParamInfo(paramName, paramValue);
                if(res === 1)
                     return true;
                systemConfigurationMessageDialog.show(qsTr("Проблема с установкой значения: "
                                                            + paramName + " = " + paramValue +
                                                            ". Проверьте введенные значения и исправьте ошибки."));
                return false;
            }
//            onClicked: {
//                if(userEditingConfiguration)
//                {
//                    systemInformationGridLayout.enabled = false;
//                    if(checkNewParamValue("model", modelTextInput.text) &&
//                            checkNewParamValue("serviceCode", serviceCodeTextInput.text) &&
//                            checkNewParamValue("hostName", hostNameTextInput.text) &&
//                            checkNewParamValue("workGroup", workGroupTextInput.text))
//                    {
//                        socketcontroller.setParamInfo("model", modelTextInput.text);
//                        socketcontroller.setParamInfo("serviceCode", serviceCodeTextInput.text);
//                        socketcontroller.setParamInfo("hostName", hostNameTextInput.text);
//                        socketcontroller.setParamInfo("workGroup", workGroupTextInput.text);
//                    }
//                }
//                else
//                    systemInformationGridLayout.enabled = true;
//                userEditingConfiguration = !userEditingConfiguration;
//                //TODO
//                // create backup to compare
//            }

//            function checkNewParamValue(paramName, paramValue)
//            {
//                var res = socketcontroller.permitSetParamInfo(paramName, paramValue);
//                if(res === 0) // 1)
//                    return true;
//                generalConfigurationMessageDialog.show(qsTr("Проблема с установкой значения: "
//                                                            + paramName + " = " + paramValue));
//                return false;
//            }
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
