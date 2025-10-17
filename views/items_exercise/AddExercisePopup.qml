import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.7)
    visible: false
    z: 1000

    // Close pop-up when clicking outside
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }

    Rectangle {
        id: formContainer
        width: 600
        height: 550
        anchors.centerIn: parent
        color: "#2a2a2a"
        radius: 20
        border.width: 2
        border.color: "#6C63FF"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 15

            // Title
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "🏋️ Add New Exercise"
                color: "#ffffff"
                font.pixelSize: 24
                font.weight: Font.Bold
            }

            // Grid with fields
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                rowSpacing: 15
                columnSpacing: 15

                // Exercise Name
                Text {
                    text: "Exercise Name"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                // Repetitions
                Text {
                    text: "Repetitions"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                // Number of Series
                Text {
                    text: "Number of Series"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                // Weight
                Text {
                    text: "Weight (kg)"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                // Grip
                Text {
                    text: "Grip"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                // Notes
                Text {
                    Layout.columnSpan: 2
                    text: "Notes"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }
            }
        }
    }
}
