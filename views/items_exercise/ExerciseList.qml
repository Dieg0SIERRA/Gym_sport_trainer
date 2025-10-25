import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components

Rectangle {
    id: root
    color: "#ecf0f1"
    
    property int userId: -1
    property var exercises: []
    signal refreshRequested()
    signal editExercise(int exerciseId)
    signal deleteExercise(int exerciseId)

    onUserIdChanged: {
        if (userId > 0) {
            loadExercises()
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 15
            
            Text {
                text: "📋 My Exercises"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#2c3e50"
            }
            
            Item { Layout.fillWidth: true }
            
            // exercise counter
            Rectangle {
                Layout.preferredWidth: 60
                Layout.preferredHeight: 35
                color: "#1E90FF"
                radius: 17.5
                
                Text {
                    anchors.centerIn: parent
                    text: root.exercises.length.toString()
                    color: "white"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                }
            }

            // Refresh Button
            Components.GenericButton {
                Layout.alignment: Qt.AlignLeft
                width: 45; height: 45; fontSize: 20; buttonRadius: 22.5
                text: "🔄"
                rotation: refreshArea.pressed ? 180 : 0
                color: refreshArea.pressed ? "#0066CC" :
                       refreshArea.containsMouse ? "#4169E1" : "#1E90FF"

                Behavior on rotation {
                    NumberAnimation { duration: 300 }
                }

                onClicked: {
                    // refresh exercise list
                }
            }
        }
        
        // Search/filter bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: "white"
            radius: 25
            border.color: searchField.activeFocus ? "#1E90FF" : "#e0e0e0"
            border.width: 2

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                Text {
                    text: "🔍"
                    font.pixelSize: 18
                }

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "Search exercises..."
                    placeholderTextColor: "#95a5a6"
                    color: "#2c3e50"
                    background: Item {}
                    font.pixelSize: 15
                    selectByMouse: true

                    // onTextChanged: filterExercises()
                }
            }
        }
        
        // Exercise list
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            // Message when there are not exercise in the list
            Column {
                anchors.centerIn: parent
                spacing: 20
                visible: filteredModel.count === 0

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "📭"
                    font.pixelSize: 64
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: searchField.text !== "" ? "No exercises found" : "No exercises yet"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: "#7f8c8d"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: searchField.text !== "" ? "Try a different search" : "Click '+ Add exercise' to get started"
                    font.pixelSize: 14
                    color: "#95a5a6"
                }
            }

            // ScrollView in the list
            ScrollView {
                anchors.fill: parent
                visible: filteredModel.count > 0
                clip: true

                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ListView {
                    id: exerciseListView
                    anchors.fill: parent
                    spacing: 15
                    model: filteredModel

                    //TODO: Exercise information
                }
            }
        }
    }
    
    ListModel {
        id: filteredModel
    }

    // Delete an exercise of the list
    Rectangle {
        id: deleteConfirmDialog
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        visible: false
        z: 1000

        property int exerciseIdToDelete: -1

        MouseArea {
            anchors.fill: parent
            onClicked: deleteConfirmDialog.visible = false
        }

        Rectangle {
            width: 350
            height: 200
            anchors.centerIn: parent
            color: "#2a2a2a"
            radius: 15
            border.width: 2
            border.color: "#d04040"

            MouseArea {
                anchors.fill: parent
                onClicked: {}
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 25
                spacing: 20

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "⚠️"
                    font.pixelSize: 48
                    color: "#d04040"
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    text: "Delete Exercise?"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    text: "This action cannot be undone"
                    font.pixelSize: 13
                    color: "#95a5a6"
                    horizontalAlignment: Text.AlignHCenter
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    spacing: 15

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 45
                        color: cancelDeleteArea.pressed ? "#5a5a5a" :
                               cancelDeleteArea.containsMouse ? "#4a4a4a" : "#3a3a3a"
                        radius: 10

                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            color: "#ffffff"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                        }

                        MouseArea {
                            id: cancelDeleteArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: deleteConfirmDialog.visible = false
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 45
                        color: confirmDeleteArea.pressed ? "#c0392b" :
                               confirmDeleteArea.containsMouse ? "#e74c3c" : "#d04040"
                        radius: 10

                        Text {
                            anchors.centerIn: parent
                            text: "Delete"
                            color: "#ffffff"
                            font.pixelSize: 15
                            font.weight: Font.Bold
                        }

                        MouseArea {
                            id: confirmDeleteArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.deleteExercise(deleteConfirmDialog.exerciseIdToDelete)
                                deleteConfirmDialog.visible = false
                            }
                        }
                    }
                }
            }
        }
    }

    // functions
    function loadExercises() {
        if (root.userId <= 0) {
            console.log("No userId set, cannot load exercises")
            return
        }

        console.log("Loading exercises for userId:", root.userId)
        root.exercises = DatabaseManager.getExercisesByUser(root.userId)
        console.log("Loaded exercises:", root.exercises.length)
        filterExercises()
    }

    function filterExercises() {
        filteredModel.clear()

        var searchText = searchField.text.toLowerCase()

        for (var i = 0; i < root.exercises.length; i++) {
            var exercise = root.exercises[i]

            // If there is search text, filter
            if (searchText !== "") {
                var nameMatch = exercise.name.toLowerCase().includes(searchText)
                var gripMatch = exercise.grip.toLowerCase().includes(searchText)
                var notesMatch = exercise.notes.toLowerCase().includes(searchText)

                if (!nameMatch && !gripMatch && !notesMatch) {
                    continue
                }
            }

            filteredModel.append(exercise)
        }
    }

    // Public function for recharging from outside
    function refresh() {
        loadExercises()
    }
}
