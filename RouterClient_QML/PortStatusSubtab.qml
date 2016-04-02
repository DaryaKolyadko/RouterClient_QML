import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab {
    id: portStatusSubtabId
    active: true
    title: qsTr("port_status")

    property int fontCoefficient: 100
    property string greenTickImg: "images/check36x36.png"
    property string greyTickImg: "images/greycheck36x36.png"

    Connections {
        target: socketcontroller
    }

    ColumnLayout{
        id: columnLayout
        anchors.fill: parent

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

        ColumnLayout{
            anchors.top: rowLayoutId.bottom
            anchors.left: columnLayout.left
            anchors.right: columnLayout.right
            anchors.bottom: columnLayout.bottom
 //           ScrollView{
       //         anchors.fill: parent

            Flickable{
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick
               // contentHeight: portStatusListView.cellHeight*portStatusModel.count

                    ListView{
                        id: portStatusListView
                        anchors.fill: parent
                        //width: columnLayout.width
                        Layout.fillWidth: true
                        anchors.leftMargin: rowLayoutId.width*0.05
                        clip: true
                        model: portStatusModel
                        delegate: portStatusListDelegate
                    }
               // }
            }
        }

        Component {
            id: portStatusListDelegate

            Item {
                id: portStatusListDelegateItem
                width: childrenRect.width
                anchors.bottomMargin: portStatusListView.width*0.02
                //height: childrenRect.height + 10
                height: ((columnLayout.height + columnLayout.width)/fontCoefficient)*19

                Row {
                    ColumnLayout {
                        width: portStatusListView.width
                        Layout.fillWidth: true

                        Row{
                            Text {
                                text: qsTr("port") + " #"
                                color: "darkGreen"
                                font.pointSize:(columnLayout.height + columnLayout.width)/(fontCoefficient - 10)
                            }
                            Text {
                                text: port
                                color: "darkGreen"
                                font.pointSize:(columnLayout.height + columnLayout.width)/(fontCoefficient - 10)
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("link")
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                            Image {
                                id: image
                                source: link
                                height: (columnLayout.height + columnLayout.width)/(fontCoefficient/2.5)
                                width: height
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("speed")
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                            Text {
                                text: speed
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("duplex")
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                            Text {
                                text: duplex
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("flow_control")
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                            Image {
                                id: image1
                                source: flow_control
                                height: (columnLayout.height + columnLayout.width)/(fontCoefficient/2.5)
                                width: height
                            }
                        }

//                        Rectangle
//                        {
//                            height: 1;
//                            width: columnLayout.width*0.8;
//                            color: "gray";
//                            anchors
//                            {
//                                left: parent.left;
//                                bottom: parent.bottom
//                            }
//                        }


                        MouseArea {
                            anchors.fill: parent

                            onClicked:{
                                portStatusListView.currentIndex = index;
                            }
                        }
                    }
                }
            }
        }

//        TableView{
//            id: portStatusView
//            objectName: "portStatusView"
//            Layout.fillWidth: true
//            horizontalScrollBarPolicy: Qt.ScrollBarAsNeeded
//            verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
//            model: portStatusModel
//            property int coefficient: 5
//            property int colWidth: portStatusView.viewport.width / coefficient

//            anchors {
//                top: rowLayoutId.bottom
//                bottom: parent.bottom
//                left: parent.left
//                right: parent.right
//            }

//            TableViewColumn{
//                id: portColumn
//                title: qsTr("port")
//                role: "port"
//                movable: false
//                resizable: true
//                width: portStatusView.colWidth/2
//            }

//            TableViewColumn {
//                id: linkColumn
//                title: qsTr("link")
//                role: "link"
//                movable: false
//                resizable: true
//                width: portStatusView.colWidth
//            }

//            TableViewColumn {
//                id: speedColumn
//                title: qsTr("speed")
//                role: "speed"
//                movable: false
//                resizable: true
//                width: portStatusView.colWidth
//            }

//            TableViewColumn {
//                id: errorCountColumn
//                title: qsTr("duplex")
//                role: "duplex"
//                movable: false
//                resizable: true
//                width: portStatusView.colWidth
//            }

//            TableViewColumn {
//                id: flowControlColumn
//                title: qsTr("flow_control")
//                role: "flow_control"
//                movable: false
//                resizable: true
//                width: portStatusView.viewport.width - portStatusView.colWidth*
//                       (portStatusView.coefficient - 1.5)
//            }
//        }

        ListModel{
            id: portStatusModel
            objectName: "portStatusModel"

            function addPortStatus(port_, link_, speed_, duplex_, flow_control_)
            {
                var linkImage = link_ === "up" ? greenTickImg : greyTickImg;
                var flowControlImage = flow_control_ === "On" ? greenTickImg : greyTickImg;
                append({port: port_, link: linkImage,
                           speed: speed_, duplex: duplex_,
                           flow_control: flowControlImage});
            }

            function getChild(index)
            {
                return get(index)
            }
        }
    }
}
