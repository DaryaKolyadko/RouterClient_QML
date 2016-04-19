import QtQuick 2.5
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ScrollView {
    id:portsCountersId
    implicitWidth: 650
    implicitHeight: 200
    clip: true
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    property int fontCoefficient: 100

    Item {
        id: content
        width: Math.max(portsCountersId.viewport.width, portCounters.implicitWidth + 2 * portCounters.rowSpacing)
        height: Math.max(portsCountersId.viewport.height, portCounters.implicitHeight + 2 * portCounters.columnSpacing)

        Connections {
            target: socketcontroller
        }

        GridLayout{
            id: portCounters
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: portsCountersId.width*0.04
            anchors.rightMargin: portCounters.rowSpacing
            anchors.topMargin: portCounters.columnSpacing
            clip: true

            Column{
                spacing: portsCountersId.width*0.04

                Repeater{
                    id: portStatusCountersRepeater
                    objectName: "portStatusContersRepeater"
                    model: portStatusCountersModel

                    Column {
                        spacing: 10

                        Row{
                            Text {
                                text: qsTr("port") + " #"
                                color: "darkGreen"
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/(fontCoefficient - 10)
                            }
                            Text {
                                text: port
                                color: "darkGreen"
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/(fontCoefficient - 10)
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("rx_packets_count")
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                            Text {
                                text: rx_packets_count
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("rx_bytes_count")
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                            Text {
                                text: rx_bytes_count
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("error_count")
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                            Text {
                                text: error_count
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("tx_packets_count")
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                            Text {
                                text: tx_packets_count
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("tx_bytes_count")
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                            Text {
                                text: tx_bytes_count
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                        }
                        Row{

                            Text {
                                text: qsTr("collisions")
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
                            }
                            Text {
                                text: collisions
                                font.pointSize:(portsCountersId.viewport.height + portsCountersId.width)/fontCoefficient
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
