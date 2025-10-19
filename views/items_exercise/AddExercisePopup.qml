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

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: "#1a1a1a"
                    radius: 8
                    border.width: exerciseNameField.activeFocus ? 2 : 1
                    border.color: exerciseNameField.activeFocus ? "#6C63FF" : "#404040"

                    TextField {
                        id: exerciseNameField
                        anchors.fill: parent
                        anchors.margins: 10
                        placeholderText: "e.g., Bench Press"
                        placeholderTextColor: "#666666"
                        color: "#ffffff"
                        background: Item {}
                        font.pixelSize: 14
                        selectByMouse: true
                    }
                }

                // Repetitions
                Text {
                    text: "Repetitions"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: "#1a1a1a"
                    radius: 8
                    border.width: repsField.activeFocus ? 2 : 1
                    border.color: repsField.activeFocus ? "#6C63FF" : "#404040"

                    TextField {
                        id: repsField
                        anchors.fill: parent
                        anchors.margins: 10
                        placeholderText: "e.g., 3 X 10"
                        placeholderTextColor: "#666666"
                        color: "#ffffff"
                        background: Item {}
                        font.pixelSize: 14
                        selectByMouse: true
                    }
                }

                // Number of Series
                Text {
                    text: "Number of Series"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: "#1a1a1a"
                    radius: 8
                    border.width: seriesField.activeFocus ? 2 : 1
                    border.color: seriesField.activeFocus ? "#6C63FF" : "#404040"

                    TextField {
                        id: seriesField
                        anchors.fill: parent
                        anchors.margins: 10
                        placeholderText: "e.g., 3"
                        placeholderTextColor: "#666666"
                        color: "#ffffff"
                        background: Item {}
                        font.pixelSize: 14
                        selectByMouse: true
                        validator: IntValidator { bottom: 1; top: 99 }
                    }
                }

                // Weight
                Text {
                    text: "Weight (kg)"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: "#1a1a1a"
                    radius: 8
                    border.width: weightField.activeFocus ? 2 : 1
                    border.color: weightField.activeFocus ? "#6C63FF" : "#404040"

                    TextField {
                        id: weightField
                        anchors.fill: parent
                        anchors.margins: 10
                        placeholderText: "e.g., 80.5"
                        placeholderTextColor: "#666666"
                        color: "#ffffff"
                        background: Item {}
                        font.pixelSize: 14
                        selectByMouse: true
                        validator: DoubleValidator { bottom: 0.0; top: 999.9; decimals: 1 }
                    }
                }

                // Grip
                Text {
                    text: "Grip"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: "#1a1a1a"
                    radius: 8
                    border.width: gripCombo.pressed ? 2 : 1
                    border.color: gripCombo.pressed ? "#6C63FF" : "#404040"

                    ComboBox {
                        id: gripCombo
                        anchors.fill: parent
                        anchors.margins: 1

                        model: ["Prono", "Supino", "Neutro", "Mixto"]

                        background: Rectangle {
                            color: gripCombo.pressed ? "#3a3a3a" : "#1a1a1a"
                            radius: 8
                        }

                        contentItem: Text {
                            leftPadding: 10
                            text: gripCombo.displayText
                            color: "#ffffff"
                            font.pixelSize: 14
                            verticalAlignment: Text.AlignVCenter
                        }

                        indicator: Text {
                            x: gripCombo.width - width - 10
                            y: gripCombo.height / 2 - height / 2
                            text: "▼"
                            color: "#6C63FF"
                            font.pixelSize: 12
                        }

                        popup: Popup {
                            y: gripCombo.height + 2
                            width: gripCombo.width
                            padding: 1

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: gripCombo.popup.visible ? gripCombo.delegateModel : null
                                currentIndex: gripCombo.highlightedIndex

                                ScrollIndicator.vertical: ScrollIndicator {}
                            }

                            background: Rectangle {
                                color: "#2a2a2a"
                                border.color: "#6C63FF"
                                border.width: 1
                                radius: 8
                            }
                        }

                        delegate: ItemDelegate {
                            width: gripCombo.width
                            contentItem: Text {
                                text: modelData
                                color: "#ffffff"
                                font.pixelSize: 14
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                            }
                            background: Rectangle {
                                color: parent.highlighted ? "#6C63FF" : "#2a2a2a"
                                opacity: parent.highlighted ? 0.8 : 1.0
                            }
                        }
                    }
                }

                // Notes (ocupa 2 columnas)
                Text {
                    Layout.columnSpan: 2
                    text: "Notes"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Rectangle {
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    color: "#1a1a1a"
                    radius: 8
                    border.width: notesArea.activeFocus ? 2 : 1
                    border.color: notesArea.activeFocus ? "#6C63FF" : "#404040"

                    Flickable {
                        anchors.fill: parent
                        anchors.margins: 10
                        contentHeight: notesArea.contentHeight
                        clip: true

                        TextArea.flickable: TextArea {
                            id: notesArea
                            placeholderText: "Additional notes about the exercise..."
                            placeholderTextColor: "#666666"
                            color: "#ffffff"
                            background: Item {}
                            font.pixelSize: 14
                            selectByMouse: true
                            wrapMode: TextArea.Wrap
                        }

                        ScrollBar.vertical: ScrollBar {}
                    }
                }
            }
            
            // TODO: Add buttons for ok and cancel
        }
    }
}
