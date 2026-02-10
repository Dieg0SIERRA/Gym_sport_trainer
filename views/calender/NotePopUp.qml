import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    visible: false
    color: "transparent"
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

    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    Rectangle {
        id: popup
        anchors.centerIn: parent
        width: 400
        height: 450
        radius: 20
        color: "white"
        border.color: "#e0e0e0"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 25
            spacing: 20

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "📝"
                    font.pixelSize: 28
                }

                Text {
                    Layout.fillWidth: true
                    text: "Add note"
                    font.pixelSize: 22
                    font.weight: Font.Bold
                    color: "#2c3e50"
                }

                // close button
                Text {
                    text: "✕"
                    font.pixelSize: 24
                    color: "#95a5a6"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.hide()
                            root.cancelled()
                        }
                    }
                }
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
                        text: "📅"
                        font.pixelSize: 20
                    }

                    Text {
                        text: formatDate(root.selectedDate)
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
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    color: "#2c3e50"
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
                            color: "white"
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
                    color: "#2c3e50"
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

            // Spacer
            Item {
                Layout.fillHeight: true
            }

            // Action button
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                // Cancel button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    radius: 12
                    color: cancelMouseArea.containsMouse ? "#e9ecef" : "#f8f9fa"
                    border.color: "#dee2e6"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: "#495057"
                    }

                    MouseArea {
                        id: cancelMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.hide()
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
                        font.pixelSize: 16
                        font.weight: Font.Bold
                        color: "white"
                    }

                    MouseArea {
                        id: saveMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (noteInput.text.trim() !== "") {
                                root.noteSaved(root.selectedDate, noteInput.text.trim(), root.currentColor)
                                root.hide()
                            }
                        }
                    }

                    Behavior on color {
                        ColorAnimation { duration: 150 }
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
}
