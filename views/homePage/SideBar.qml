import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: sidebar
    color: "#2c3e50"

    property string currentSection: "home"

    // signal to notify changes
    signal sectionChanged(string section)

    Column {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        // upper spacer
        Item {
            width: parent.width
            height: 40
        }

        // Menu Items
        Repeater {
            model: [
                { name: "Home", icon: "🏠", section: "home" },
                { name: "Seance", icon: "🏋️", section: "seance" },
                { name: "Exercise", icon: "🏃", section: "exercise" },
                { name: "Program", icon: "📋", section: "program" },
                { name: "Stats", icon: "📊", section: "stats" }
            ]

            delegate: Rectangle {
                width: sidebar.width
                height: 60
                color: sidebar.currentSection === modelData.section ? "#34495e" : "transparent"

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        sidebar.sectionChanged(modelData.section)
                        console.log("Selected section:", modelData.section)
                    }

                    onEntered: {
                        parent.color = sidebar.currentSection === modelData.section ? "#34495e" : "#3d566e"
                    }

                    onExited: {
                        parent.color = sidebar.currentSection === modelData.section ? "#34495e" : "transparent"
                    }
                }

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 15

                    // Icono
                    Text {
                        text: modelData.icon
                        font.pixelSize: 18
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Text
                    Text {
                        text: modelData.name
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Section indicator (sidebar)
                Rectangle {
                    width: 4
                    height: parent.height
                    color: "#3498db"
                    anchors.right: parent.right
                    visible: sidebar.currentSection === modelData.section
                }
            }
        }

        // space to to push-up elements
        Item {
            width: parent.width
            height: parent.height - 40 - (60 * 5) // altura restante
        }
    }
}

