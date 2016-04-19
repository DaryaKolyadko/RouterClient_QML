import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ScrollView {
    id:portStatusId
    implicitWidth: 650
    implicitHeight: 200
    clip: true
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    property int fontCoefficient: 100
    property string greenTickImg: "images/check36x36.png"
    property string greyTickImg: "images/greycheck36x36.png"

    Item {
        id: content
        width: Math.max(portStatusId.viewport.width, portStatus.implicitWidth + 2 * portStatus.rowSpacing)
        height: Math.max(portStatusId.viewport.height, portStatus.implicitHeight + 2 * portStatus.columnSpacing)

        Connections {
            target: socketcontroller
        }

        GridLayout{
            id: portStatus
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: portStatusId.width*0.04
            anchors.rightMargin: portStatus.rowSpacing
            anchors.topMargin: portStatus.columnSpacing
            clip: true

            Column{
                spacing: portStatusId.width*0.04

                Repeater{
                    id: portStatusRepeater
                    objectName: "portStatusRepeater"
                    model: portStatusModel


                    Column {
                        spacing: 10

                        Row{
                            Text {
                                text: qsTr("port") + " #"
                                color: "darkGreen"
                                font.pointSize:(portStatusId.viewport.height + portStatusId.width)/(fontCoefficient - 10)
                            }
                            Text {
                                text: port
                                color: "darkGreen"
                                font.pointSize:(portStatusId.viewport.height + portStatusId.width)/(fontCoefficient - 10)
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("link")
                                font.pointSize:(portStatusId.viewport.height + portStatusId.width)/fontCoefficient
                            }
                            Image {
                                id: image
                                source: link
                                height: (portStatusId.viewport.height + portStatusId.width)/(fontCoefficient/2.2)
                                width: height
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("speed")
                                font.pointSize:(portStatusId.viewport.height + portStatusId.width)/fontCoefficient
                            }
                            Text {
                                text: speed
                                font.pointSize:(portStatusId.viewport.height + portStatusId.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("duplex")
                                font.pointSize:(portStatusId.viewport.height + portStatusId.width)/fontCoefficient
                            }
                            Text {
                                text: duplex
                                font.pointSize:(portStatusId.viewport.height + portStatusId.width)/fontCoefficient
                            }
                        }
                        Row{
                            Text {
                                text: qsTr("flow_control")
                                font.pointSize:(portStatusId.viewport.height + portStatusId.width)/fontCoefficient
                            }
                            Image {
                                id: image1
                                source: flow_control
                                height: (portStatusId.viewport.height + portStatusId.width)/(fontCoefficient/2.2)
                                width: height
                            }
                        }
                    }
                }
            }
        }

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
