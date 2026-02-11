import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.7)
    visible: false
    z: 1000

    property date selectedDate: new Date()
    property string currentNote: ""
    property string currentColor: "#1E90FF"

    property var colorPalette: [
        "#FF6B6B", // Rojo
        "#4ECDC4", // Turquesa
        "#45B7D1", // Azul claro
        "#FFA07A", // Naranja claro
        "#98D8C8", // Verde menta
        "#F7DC6F", // Amarillo
        "#BB8FCE", // Morado
        "#1E90FF", // Azul
        "#52B788", // Verde
        "#E63946", // Rojo oscuro
        "#457B9D", // Azul grisáceo
        "#F4A261"  // Naranja
    ]

    signal noteSaved(date noteDate, string text, string color)
    signal cancelled()

    // Close pop-up when clicking outside
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }

    // Main container
    Rectangle {
        id: notePopup
        width: 400
        height: 450
        radius: 20
        anchors.centerIn: parent
        color: "#2a2a2a"
        border.color: "#6C63FF"
        border.width: 2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 15

            // Title
            Text {
                Layout.alignment: Qt.AlignLeft
                text: "📝 Add note"
                color: "#ffffff"
                font.pixelSize: 24
                font.weight: Font.Bold
            }

            // Date selected
            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: 10
                color: "#f8f9fa"
                border.color: "#e9ecef"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    Text {
                        text: "📅  " + formatDate(root.selectedDate)
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: "#2c3e50"
                    }
                }
            }

            // field text for the note
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Note:"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    clip: true

                    TextArea {
                        id: noteInput
                        placeholderText: "Write your note here..."
                        font.pixelSize: 14
                        wrapMode: TextArea.Wrap
                        selectByMouse: true

                        background: Rectangle {
                            radius: 10
                            color: "#ffffff"
                            border.color: noteInput.activeFocus ? root.currentColor : "#e0e0e0"
                            border.width: 2
                        }
                    }
                }
            }

            // Color selector
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Color:"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "#ffffff"
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 6
                    rowSpacing: 10
                    columnSpacing: 10

                    Repeater {
                        model: root.colorPalette

                        Rectangle {
                            width: 45
                            height: 45
                            radius: 22.5
                            color: modelData
                            border.color: root.currentColor === modelData ? "#2c3e50" : "transparent"
                            border.width: 3

                            // Selection indicator
                            Rectangle {
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                radius: 10
                                color: "white"
                                visible: root.currentColor === modelData

                                Text {
                                    anchors.centerIn: parent
                                    text: "✓"
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                    color: modelData
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.currentColor = modelData
                                }
                            }

                            // Hover effect
                            scale: colorMouseArea.containsMouse ? 1.1 : 1.0
                            Behavior on scale {
                                NumberAnimation { duration: 100 }
                            }

                            MouseArea {
                                id: colorMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.currentColor = modelData
                                }
                            }
                        }
                    }
                }
            }

            // Action button
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 10
                spacing: 15

                Item { Layout.fillWidth: true } // Spacer

                // Cancel button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    radius: 12
                    color: cancelArea.pressed ? "#5a5a5a" :
                           cancelArea.containsMouse ? "#4a4a4a" : "#3a3a3a"

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "#ffffff"
                        font.pixelSize: 18
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: cancelArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            root.visible = false
                            root.cancelled()
                        }
                    }
                }

                // Save button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    radius: 12
                    color: saveMouseArea.pressed ? "#0066CC" :
                           (saveMouseArea.containsMouse ? "#4169E1" : root.currentColor)

                    Text {
                        anchors.centerIn: parent
                        text: "Save"
                        color: "#ffffff"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: saveMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (noteInput.text.trim() !== "")
                            {
                                root.noteSaved(root.selectedDate, noteInput.text.trim(), root.currentColor)
                                root.hide()
                            }
                        }
                    }
                }
            }
        }
    }

    function formatDate(date)
    {
        var months = ["January", "February", "March", "April", "May", "June",
                      "July", "August", "September", "October", "November", "December"]
        var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

        return days[date.getDay()] + ", " +
               date.getDate() + " - " +
               months[date.getMonth()] + " - " +
               date.getFullYear()
    }

    function show(date, existingNote, existingColor) {
        selectedDate = date
        currentNote = existingNote || ""
        currentColor = existingColor || "#1E90FF"

        noteInput.text = currentNote
        root.visible = true
    }

    function hide() {
        root.visible = false
        noteInput.text = ""
        currentNote = ""
        currentColor = "#1E90FF"
    }
}
