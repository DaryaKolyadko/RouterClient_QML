import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

Item {
    id: configurationForm
    visible: true
    width: 800//resolution.dp(800) //800
    height: 400// resolution.dp(400)//400

    property int bottomMargin: 15//resolution.dp(15)//15
    property int fontCoefficient: 100// resolution.dp(100)//100

    Connections {
        target: socketcontroller
        onWifiComboBoxSetText:{
            wifiConfigurationTab.wifiStatusComboVal = text;
            console.debug(wifiConfigurationTab.wifiStatusComboVal);
        }
    }

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

//    ResolutionController{
//        id: resolution
//    }
}
