import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components

Rectangle {
    id: root
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.7)
    visible: false
    z: 1000

    property int templateId: -1
    property string templateName: ""
    property var variations: []

    signal cancelled()

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.visible = false
            root.cancelled()
        }
    }

    Rectangle {
        width: 600
        height: 650
        anchors.centerIn: parent
        color: "#2a2a2a"
        radius: 20
        border.width: 2
        border.color: "#6C63FF"

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 25
            spacing: 15

            // Title
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "📈 Progress: " + root.templateName
                color: "#ffffff"
                font.pixelSize: 22
                font.weight: Font.Bold
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#6C63FF"
                opacity: 0.3
            }

            // Empty state
            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                visible: root.variations.length === 0
                text: "No variations recorded yet"
                color: "#7f8c8d"
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
            }

            // Close button
            Components.GenericButton {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 120
                Layout.preferredHeight: 40
                buttonRadius: 10
                fontSize: 14
                text: "Close"
                normalColor: "#3a3a3a"
                hoverColor: "#4a4a4a"
                pressedColor: "#5a5a5a"
                onClicked: {
                    root.visible = false
                    root.cancelled()
                }
            }
        }
    }
}
