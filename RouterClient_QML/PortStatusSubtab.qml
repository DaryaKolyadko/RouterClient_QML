import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab {
    id: portStatusSubtabId
    active: true
    title: qsTr("port_status")

    Connections {
        target: socketcontroller
    }

    ColumnLayout{

        RowLayout{
            id: rowLayoutId

            Button{
                id: updatePortStatusListButton
                text: qsTr("update_port_status_list")
                Layout.fillWidth: true
                onClicked: {
                    socketcontroller.getPortStatusList();
                }
            }
        }

        TableView{
            id: portStatusView
            objectName: "portStatusView"
            Layout.fillWidth: true
            horizontalScrollBarPolicy: Qt.ScrollBarAsNeeded
            verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
            model: portStatusModel
            property int coefficient: 5
            property int colWidth: portStatusView.viewport.width / coefficient

            anchors {
                top: rowLayoutId.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            TableViewColumn{
                id: portColumn
                title: qsTr("port")
                role: "port"
                movable: false
                resizable: true
                width: portStatusView.colWidth/2
            }

            TableViewColumn {
                id: linkColumn
                title: qsTr("link")
                role: "link"
                movable: false
                resizable: true
                width: portStatusView.colWidth
            }

            TableViewColumn {
                id: speedColumn
                title: qsTr("speed")
                role: "speed"
                movable: false
                resizable: true
                width: portStatusView.colWidth
            }

            TableViewColumn {
                id: errorCountColumn
                title: qsTr("duplex")
                role: "duplex"
                movable: false
                resizable: true
                width: portStatusView.colWidth
            }

            TableViewColumn {
                id: flowControlColumn
                title: qsTr("flow_control")
                role: "flow_control"
                movable: false
                resizable: true
                width: portStatusView.viewport.width - portStatusView.colWidth*
                       (portStatusView.coefficient - 1.5)
            }
        }

        ListModel{
            id: portStatusModel
            objectName: "portStatusModel"

            function addPortStatus(port_, link_, speed_, duplex_, flow_control_)
            {
                append({port: port_, link: link_,
                           speed: speed_, duplex: duplex_,
                           flow_control: flow_control_});
            }

            function getChild(index)
            {
                return get(index)
            }
        }
    }
}
