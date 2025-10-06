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
			id: dashboard
			anchors.fill: parent
			color: "#ecf0f1"
		
			Column {
				width: parent.width
				spacing: 20
				anchors.top: parent.top
				anchors.horizontalCenter: parent.horizontalCenter
		
				Row {
					spacing: 10
					width: parent.width
		
					Repeater {
						model: ListModel {
							ListElement { label: "Add seance"; icon: "?" }
							ListElement { label: "Add exercise"; icon: "?" }
							ListElement { label: "Add program"; icon: "?" }
						}
		
						delegate: Rectangle {
							width: 150; height: 50
							radius: 25
							color: "#1E90FF"
		
							Text {
								text: model.icon + " " + model.label
								anchors.centerIn: parent
								color: "white"
								font.bold: true
							}
						}
					}
				}
		
				// Tarjetas de estadísticas (dinámicas)
				Repeater {
					model: ListModel {
						ListElement { title: "Time in gym"; value: "3h 20min"; icon: "??" }
						ListElement { title: "Time running"; value: "12 km"; icon: "??" }
						ListElement { title: "Calories burned"; value: "550 kcal"; icon: "??" }
					}
		
					delegate: Rectangle {
						Layout.fillWidth: true
						height: 120
						radius: 12
						color: "white"
						border.color: "#ddd"
		
						Column {
							anchors.centerIn: parent
							spacing: 5
							Text { text: model.icon; font.pixelSize: 24; horizontalAlignment: Text.AlignHCenter }
							Text { text: model.value; font.pixelSize: 22; font.bold: true; color: "#333"; horizontalAlignment: Text.AlignHCenter }
							Text { text: model.title; font.pixelSize: 14; color: "#777"; horizontalAlignment: Text.AlignHCenter }
						}
					}
				}
			}
		}
    }
}
