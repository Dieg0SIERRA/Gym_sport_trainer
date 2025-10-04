import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    anchors.fill: parent
    color: "#f5f5f5"

    // Property to active item in the sidebar
    property string currentSection: "home"

    Row {
        anchors.fill: parent
        spacing: 0

        // --- SIDEBAR ---
        Rectangle {
            id: sidebar
            width: 280
            height: parent.height
            color: "#2c3e50"

            Column {
                anchors.fill: parent
                anchors.margins: 0
                spacing: 0

                // Espaciado superior
                Item {
                    width: parent.width
                    height: 40
                }

                // Menu Items
                Repeater {
                    model: [
                        { name: "Home", icon: "??", section: "home" },
                        { name: "Seance", icon: "???", section: "seance" },
                        { name: "Exercise", icon: "??", section: "exercise" },
                        { name: "Program", icon: "??", section: "program" },
                        { name: "Stats", icon: "??", section: "stats" }
                    ]

                    delegate: Rectangle {
                        width: sidebar.width
                        height: 60
                        color: root.currentSection === modelData.section ? "#34495e" : "transparent"

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                root.currentSection = modelData.section
                                console.log("Selected section:", modelData.section)
                            }

                            onEntered: parent.color = root.currentSection === modelData.section ? "#34495e" : "#3d566e"
                            onExited: parent.color = root.currentSection === modelData.section ? "#34495e" : "transparent"
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
                            visible: root.currentSection === modelData.section
                        }
                    }
                }

                // space to to push-up elements
                Item {
                    width: parent.width
                    Layout.fillHeight: true
                }
            }
        }

        // --- Main area (placeholder) ---
        Rectangle {
            width: parent.width - sidebar.width
            height: parent.height
            color: "#ecf0f1"

            // content of placeholder
            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "Sección: " + root.currentSection.toUpperCase()
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: "#2c3e50"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Aquí irá el contenido del dashboard"
                    font.pixelSize: 16
                    color: "#7f8c8d"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
