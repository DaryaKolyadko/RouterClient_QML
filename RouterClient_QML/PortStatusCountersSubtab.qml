import QtQuick 2.5
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Tab {
    id: portStatusCountersSubtabId
    active: true
    title: qsTr("port_status_counters")
    property int fontCoefficient: 100

    Connections {
        target: socketcontroller
    }

    ColumnLayout{
        id: columnLayout
        anchors.fill: parent

        RowLayout{
            id: rowLayoutId

            Button{
                id: updatePortStatusCountersListButton
                text: qsTr("update_port_status_counters_list")
                Layout.fillWidth: true
                onClicked: {
                    socketcontroller.getPortStatusCountersList();
                }
            }
        }

        ColumnLayout{
            anchors.top: rowLayoutId.bottom
 //           ScrollView{
       //         anchors.fill: parent

            Flickable{
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick

                    ListView{
                        id: portStatusCountersListView
                        anchors.fill: parent
                        width: columnLayout.width
                        anchors.leftMargin: rowLayoutId.width*0.05
                        clip: true
                        model: portStatusCountersModel
                        delegate: portStatusCountersListDelegate
                    }
               // }
            }
        }

        Component {
            id: portStatusCountersListDelegate

            Item {
                id: portStatusCountersListDelegateItem
                width: childrenRect.width //portStatusCountersListView.width
                anchors.bottomMargin: portStatusCountersListView.width*0.02
                //height: childrenRect.height + 10
                height: ((columnLayout.height + columnLayout.width)/fontCoefficient)*24

                Row {
                    ColumnLayout {
                        width: portStatusCountersListView.width
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
                                text: qsTr("rx_packets_count")
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                            Text {
                                text: rx_packets_count
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("rx_bytes_count")
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                            Text {
                                text: rx_bytes_count
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("error_count")
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                            Text {
                                text: error_count
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("tx_packets_count")
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                            Text {
                                text: tx_packets_count
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("tx_bytes_count")
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                            Text {
                                text: tx_bytes_count
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("collisions")
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                            Text {
                                text: collisions
                                font.pointSize:(columnLayout.height + columnLayout.width)/fontCoefficient
                            }
                        }
//                        Rectangle
//                        {
//                            height: 1;
//                            width: columnLayout.width*0.8;
//                            color: "gray";
//                           // anchors.leftMargin: columnLayout.width*0.1
//                            anchors
//                            {
//                                left: parent.left;
//                                bottom: parent.bottom
//                            }
//                        }


                        MouseArea {
                            anchors.fill: parent

                            onClicked:{
                                portStatusCountersListView.currentIndex = index;
                            }
                        }
                    }
                }
            }
        }

        ListModel{
            id: portStatusCountersModel
            objectName: "portStatusCountersModel"

            function addPortStatusCounter(port_, rx_packets_count_, rx_bytes_count_,
                                          error_count_, tx_packets_count_, tx_bytes_count_,
                                          collisions_)
            {
                append({port: port_, rx_packets_count: rx_packets_count_,
                           rx_bytes_count: rx_bytes_count_,
                           error_count: error_count_,
                           tx_packets_count: tx_packets_count_,
                           tx_bytes_count: tx_bytes_count_,
                           collisions: collisions_})
            }

            function getChild(index)
            {
                return get(index)
            }
        }
    }
}
