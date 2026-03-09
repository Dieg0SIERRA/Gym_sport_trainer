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

    // Edit mode properties for creating variations
    property bool editMode: false              // true = creating variation from existing template
    property int templateId: -1                // Template ID when editMode = true
    property string fixedTemplateName: ""      // Fixed template name when editMode = true

    signal exerciseAdded(string name, string reps, int series, real weight, string grip, string notes)
    signal cancelled()

    // Close pop-up when clicking outside
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }

    // Main container
    Rectangle {
        id: formContainer
        width: 600
        height: 550
        anchors.centerIn: parent
        color: "#2a2a2a"
        radius: 20
        border.width: 2
        border.color: "#6C63FF"

        // Prevent the click from closing the pop-up
        MouseArea {
            anchors.fill: parent
            onClicked: {} // No hace nada, solo previene propagación
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 15

            // Title
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.editMode ? "✏️ Create Variation" : "🏋️ Add New Exercise"
                color: "#ffffff"
                font.pixelSize: 24
                font.weight: Font.Bold
            }

            // Separator line
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#6C63FF"
                opacity: 0.3
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
                    color: root.editMode ? "#0d0d0d" : "#1a1a1a"
                    radius: 8
                    border.width: exerciseNameField.activeFocus ? 2 : 1
                    border.color: root.editMode ? "#2a2a2a" : (exerciseNameField.activeFocus ? "#6C63FF" : "#404040")

                    TextField {
                        id: exerciseNameField
                        anchors.fill: parent
                        anchors.margins: 10
                        placeholderText: "e.g., Bench Press"
                        placeholderTextColor: "#666666"
                        color: root.editMode ? "#7f8c8d" : "#ffffff"
                        background: Item {}
                        font.pixelSize: 14
                        selectByMouse: !root.editMode
                        readOnly: root.editMode
                        enabled: !root.editMode
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

            // Actions button
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 10
                spacing: 15

                Item { Layout.fillWidth: true } // Spacer

                // Buttonn Cancel
                Rectangle {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 45
                    color: cancelArea.pressed ? "#5a5a5a" :
                           cancelArea.containsMouse ? "#4a4a4a" : "#3a3a3a"
                    radius: 10

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: "#ffffff"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: cancelArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            clearFields()
                            root.visible = false
                            root.cancelled()
                        }
                    }
                }

                // Button Add Exercise / Create Variation
                Rectangle {
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 45
                    color: !isFormValid() ? "#404040" :
                           addArea.pressed ? "#5A52E8" :
                           addArea.containsMouse ? "#7B73FF" : "#6C63FF"
                    radius: 10
                    opacity: isFormValid() ? 1.0 : 0.6

                    Text {
                        anchors.centerIn: parent
                        text: root.editMode ? "Create Variation" : "Add Exercise"
                        color: "#ffffff"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                    }

                    MouseArea {
                        id: addArea
                        anchors.fill: parent
                        hoverEnabled: isFormValid()
                        cursorShape: isFormValid() ? Qt.PointingHandCursor : Qt.ArrowCursor
                        enabled: isFormValid()

                        onClicked: {
                            if (isFormValid()) {
                                handleSave()
                                clearFields()
                                root.visible = false
                            }
                        }
                    }
                }
            }
        }
    }

    function isFormValid() {
        return exerciseNameField.text.trim() !== "" &&
               repsField.text.trim() !== "" &&
               seriesField.text.trim() !== "" &&
               weightField.text.trim() !== ""
    }

    function clearFields() {
        exerciseNameField.text = ""
        repsField.text = ""
        seriesField.text = ""
        weightField.text = ""
        gripCombo.currentIndex = 0
        notesArea.text = ""
        root.editMode = false
        root.templateId = -1
        root.fixedTemplateName = ""
    }

    function show() {
        clearFields()
        root.visible = true
    }

    // New function: Show popup in variation creation mode
    function showForVariation(templateIdParam, templateName, baseVariation) {
        clearFields()

        root.editMode = true
        root.templateId = templateIdParam
        root.fixedTemplateName = templateName

        // Pre-fill fields with base variation data
        exerciseNameField.text = templateName
        repsField.text = baseVariation.repetitions || ""
        seriesField.text = baseVariation.series ? baseVariation.series.toString() : ""
        weightField.text = baseVariation.weight ? baseVariation.weight.toString() : ""

        // Set grip combo box
        var gripOptions = ["Prono", "Supino", "Neutro", "Mixto"]
        var gripIndex = gripOptions.indexOf(baseVariation.grip)
        gripCombo.currentIndex = gripIndex >= 0 ? gripIndex : 0

        notesArea.text = baseVariation.notes || ""

        root.visible = true
    }

    // Handle save logic (template + variation OR just variation)
    function handleSave() {
        var name = exerciseNameField.text
        var reps = repsField.text
        var series = parseInt(seriesField.text)
        var weight = parseFloat(weightField.text)
        var grip = gripCombo.currentText
        var notes = notesArea.text

        // Emit signal for Dashboard to handle
        root.exerciseAdded(name, reps, series, weight, grip, notes)
    }
}
