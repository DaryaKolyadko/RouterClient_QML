import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

Item {
    id: configurationForm
    visible: true
    width: 800
    height: 400

   // Component.onCompleted: {
       // wifiConfigurationTab.addWifiStatus("Выключена");
//        wifiConfigurationTab.addWifiStatus("Включена");
//        frequencyRangeListModel.append({text: "2.4 Hz"})
//        frequencyRangeListModel.append({text: "5.0 Hz"})
//        wifiStatusListModel.append({text: "Выключена"})
//        wifiStatusListModel.append({text: "Включена"})
   // }

    property int bottomMargin: 15
    property int fontCoefficient: 100//115

    TabView{
        id: tabView
        objectName: "tabView"
        anchors.fill: parent

// в идеале должно быть так (но так в c++ child == null)
        GeneralConfigurationTab{
            id: generalConfigurationTab
            objectName: "generalConfigurationTab"
            anchors.fill: parent
          //  bottomMargin: bottomMargin
          //  fontCoefficient: fontCoefficient
        }

        WifiConfigurationTab{
            id: wifiConfigurationTab
            objectName: "wifiConfigurationTab"
            anchors.fill: parent
          //  bottomMargin: bottomMargin
          //  fontCoefficient: fontCoefficient
        }

        SystemInformationTab{
            id: systemInformationTab
            objectName: "systemInformationTab"
            anchors.fill: parent
         //   bottomMargin: bottomMargin
         //   fontCoefficient: fontCoefficient
        }

        Tab{
            id: helloTab
            objectName: "helloTab"
            title: "Hello"

            Item{
                Rectangle{
                    color:"#E8FDDF"
                    width: parent.width
                    height: parent.height
                }

                anchors.fill: parent

                GridLayout {
                    id: gridLayoutHello
                    width: parent.parent.width*3/5
                    columns: 2
                    anchors.centerIn: parent

                    Text{
                        id: greetingLabel
                        objectName: "greetingLabel"
                        font.bold: true
                        font.letterSpacing: 1
                        font.pointSize: (parent.parent.height + parent.parent.width)/50
                        color: "#60D511"
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Text{
                        id: enterNameLabel
                        font.bold: true
                        font.letterSpacing: 1
                        font.pointSize: (parent.parent.height + parent.parent.width)/110
                        color: "#0C8F33"
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        text: qsTr("Введите ваше имя:")
                    }

                    TextField{
                        id: enterNameTextField
                        objectName: "enterNameTextField"
                        font.bold: true
                        font.letterSpacing: 1
                        font.pointSize: (parent.parent.height + parent.parent.width)/110
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        style:  MyTextFieldStyle{id: hellofield}
                    }

                    Button{
                        id: sayHelloButton
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        text: qsTr("Пусть программа со мной поздоровается")
                    }
                }
            }
    }
}


//====================================================================

//        ListModel {
//            id: frequencyRangeListModel
//        }

//        ListModel{
//            id: wifiStatusListModel
//        }

}
