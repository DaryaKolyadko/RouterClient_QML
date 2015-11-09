import QtQuick 2.3
import QtQuick.Controls.Styles 1.4

Component {
    id: textFieldStyle
    TextFieldStyle
    {
        textColor: "black"
        background: Rectangle {
            radius: height/4
            border.color: "lightgrey"
            border.width: 2
        }
    }
}
