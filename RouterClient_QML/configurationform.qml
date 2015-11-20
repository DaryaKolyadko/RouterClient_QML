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

    //DELETE THIS IN THE END
//    Component.onCompleted: {
//        wifiConfigurationTab.addWifiStatus("Выключена");
//        wifiConfigurationTab.addWifiStatus("Включена");
//        frequencyRangeListModel.append({text: "2.4 Hz"})
//        frequencyRangeListModel.append({text: "5.0 Hz"})
//        wifiStatusListModel.append({text: "Выключена"})
//        wifiStatusListModel.append({text: "Включена"})
//    }

    property int bottomMargin: 15
    property int fontCoefficient: 100

    TabView{
        id: tabView
        objectName: "tabView"
        anchors.fill: parent

        GeneralConfigurationTab{
            id: generalConfigurationTab
            objectName: "generalConfigurationTab"
            active: true
            anchors.fill: parent
            fontCoefficient: fontCoefficient
        }

        WifiConfigurationTab{
            id: wifiConfigurationTab
            objectName: "wifiConfigurationTab"
            anchors.fill: parent
            bottomMargin: bottomMargin
        }

        SystemInformationTab{
            id: systemInformationTab
            objectName: "systemInformationTab"
            anchors.fill: parent
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

//}
