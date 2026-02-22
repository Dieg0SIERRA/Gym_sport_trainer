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

    signal seanceAdded(string name, var exercises, string warmUp, string notes)
    signal cancelled()

    // ── Edit mode properties ──
    property bool editMode: false
    property int editSeanceId: -1
    signal seanceUpdated(int seanceId, string name, var exercises, string warmUp, string notes)


    ListModel {
        id: exercisesModel
        ListElement { name: "" }
    }

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
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 15

            // Title
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.editMode ? "✏️ Edit Seance" : "🏋️ Add New Seance"
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

                // Seance Name
                Components.GenericTextField {
                    id: seanceNameField
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    labelText: "Seance Name"
                    placeholderText: "e.g., Push seance"
                    fieldBackgroundColor: "#1a1a1a"
                    fieldRadius: 8
                    fontSize: 14
                    labelFontSize: 14
                }

                // Warm-up exercise
                Text {
                    text: "Warm-up exercise"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    color: "#1a1a1a"
                    radius: 8
                    border.width: warmUpExercise.pressed ? 2 : 1
                    border.color: warmUpExercise.pressed ? "#6C63FF" : "#404040"

                    ComboBox {
                        id: warmUpExercise
                        anchors.fill: parent
                        anchors.margins: 1

                        model: ["-------", "Running", "Cycling", "Elliptical ", "Stretching", "Nothing"]

                        background: Rectangle {
                            color: warmUpExercise.pressed ? "#3a3a3a" : "#1a1a1a"
                            radius: 8
                        }

                        contentItem: Text {
                            leftPadding: 10
                            text: warmUpExercise.displayText
                            color: "#ffffff"
                            font.pixelSize: 14
                            verticalAlignment: Text.AlignVCenter
                        }

                        indicator: Text {
                            x: warmUpExercise.width - width - 10
                            y: warmUpExercise.height / 2 - height / 2
                            text: "▼"
                            color: "#6C63FF"
                            font.pixelSize: 12
                        }

                        popup: Popup {
                            y: warmUpExercise.height + 2
                            width: warmUpExercise.width
                            padding: 1

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: warmUpExercise.popup.visible ? warmUpExercise.delegateModel : null
                                currentIndex: warmUpExercise.highlightedIndex

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
                            width: warmUpExercise.width
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

                // Exercise Name
                Text {
                    Layout.columnSpan: 2
                    text: "Exercises"
                    color: "#b0b0b0"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                ColumnLayout {
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    spacing: 10

                    Repeater {
                        model: exercisesModel

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Components.GenericTextField {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 45
                                labelText: ""
                                placeholderText: "e.g., Bench Press"
                                fieldBackgroundColor: "#1a1a1a"
                                fieldRadius: 8
                                fontSize: 14
                                labelFontSize: 14

                                text: name
                                onTextChanged: exercisesModel.setProperty(index, "name", text)
                            }

                            Rectangle {
                                Layout.preferredWidth: 40
                                Layout.preferredHeight: 45
                                radius: 8
                                color: removeArea.pressed ? "#5a5a5a" :
                                       removeArea.containsMouse ? "#4a4a4a" : "#3a3a3a"
                                opacity: exercisesModel.count > 1 ? 1.0 : 0.5

                                Text {
                                    anchors.centerIn: parent
                                    text: "−"
                                    color: "#ffffff"
                                    font.pixelSize: 20
                                    font.weight: Font.DemiBold
                                }

                                MouseArea {
                                    id: removeArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: exercisesModel.count > 1 ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    enabled: exercisesModel.count > 1
                                    onClicked: exercisesModel.remove(index)
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 160
                        Layout.preferredHeight: 40
                        radius: 10
                        color: addExerciseArea.pressed ? "#5A52E8" :
                               addExerciseArea.containsMouse ? "#7B73FF" : "#6C63FF"

                        Text {
                            anchors.centerIn: parent
                            text: "+ Add exercise"
                            color: "#ffffff"
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: addExerciseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: exercisesModel.append({ "name": "" })
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
                            placeholderText: "Additional notes about the seance..."
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

                // Button Add Seance
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
                        text: root.editMode ? "Save Changes" : "Add Seance"
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
                                if (root.editMode) {
                                    root.seanceUpdated(
                                        root.editSeanceId,
                                        seanceNameField.text,
                                        getExercises().join(", "),
                                        warmUpExercise.currentText,
                                        notesArea.text
                                    )
                                }
                                else {
                                    root.seanceAdded(
                                        seanceNameField.text,
                                        getExercises().join(", "),
                                        warmUpExercise.currentText,
                                        notesArea.text
                                    )
                                }
                                clearFields()
                                root.visible = false
                            }
                        }
                    }
                }
            }
        }
    }

    function getExercises() {
        var list = []
        for (var i = 0; i < exercisesModel.count; i++) {
            var name = (exercisesModel.get(i).name || "").trim()
            if (name !== "")
                list.push(name)
        }
        return list
    }

    function isFormValid() {
        var hasName = seanceNameField.text.trim() !== ""
        var hasExercises = getExercises().length > 0
        var hasValidWarmUp = warmUpExercise.currentIndex > 0
        return hasName && hasExercises && hasValidWarmUp
    }

    function clearFields() {
        // seanceNameField.clear()
        exercisesModel.clear()
        exercisesModel.append({ "name": "" })
        warmUpExercise.currentIndex = 0
        notesArea.text = ""
    }

    function show() {
        clearFields()
        root.visible = true
    }

    function showEdit(seanceId, name, exercises, warmUp, notes) {
        editMode = true
        editSeanceId = seanceId
        clearFields()

        // Pre-fill fields
        seanceNameField.text = name
        notesArea.text = notes

        // Set warm-up combo box
        var warmUpOptions = ["-------", "Running", "Cycling", "Elliptical ", "Stretching", "Nothing"]
        var idx = warmUpOptions.indexOf(warmUp)
        warmUpExercise.currentIndex = idx >= 0 ? idx : 0

        // Populate exercises
        exercisesModel.clear()
        var exerciseArray = exercises.split(",")
        for (var i = 0; i < exerciseArray.length; i++) {
            var trimmed = exerciseArray[i].trim()
            if (trimmed !== "")
                exercisesModel.append({ "name": trimmed })
        }
        if (exercisesModel.count === 0)
            exercisesModel.append({ "name": "" })

        root.visible = true
    }
}
