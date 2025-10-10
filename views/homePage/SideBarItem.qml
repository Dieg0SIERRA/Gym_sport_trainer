import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root

    property string itemName: ""
    property string itemIcon: ""
    property string itemSection: ""
    property bool isActive: false

    // Signal
    signal clicked()

    // visual status
    color: isActive ? "#34495e" : "transparent"

    // visual transitions
    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.clicked()

        onEntered: {
            if (!root.isActive) {
                parent.color = "#3d566e"
            }
        }

        onExited: {
            if (!root.isActive) {
                parent.color = "transparent"
            }
        }
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        spacing: 15

        Text {
            text: root.itemIcon
            font.pixelSize: 18
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.itemName
            font.pixelSize: 16
            font.weight: Font.Medium
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // section indicator
    Rectangle {
        width: 4
        height: parent.height
        color: "#3498db"
        anchors.right: parent.right
        visible: root.isActive

        Behavior on visible {
            NumberAnimation { duration: 200 }
        }
    }
}
