import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components" as Components

Rectangle {
    id: root
    color: "#ecf0f1"

    property int userId: -1
    property var seances: []

    signal refreshRequested()
    signal editSeance(int seanceId)
    signal deleteSeance(int seanceId)

    onUserIdChanged: {
        if (userId > 0) {
            loadSeances()
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
                text: "🏋️ My Seances"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#2c3e50"
            }

            Item { Layout.fillWidth: true }

            // Seance counter
            Rectangle {
                Layout.preferredWidth: 60
                Layout.preferredHeight: 35
                color: "#1E90FF"
                radius: 17.5

                Text {
                    anchors.centerIn: parent
                    text: root.seances.length.toString()
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
                    loadSeances()
                    root.refreshRequested()
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
                    placeholderText: "Search seances..."
                    placeholderTextColor: "#95a5a6"
                    color: "#2c3e50"
                    background: Item {}
                    font.pixelSize: 15
                    selectByMouse: true

                    onTextChanged: filterSeances()
                }
            }
        }

        // Seance list
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            // Message when there are no seances in the list
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
                    text: searchField.text !== "" ? "No seances found" : "No seances yet"
                    font.pixelSize: 20
                    font.weight: Font.Medium
                    color: "#7f8c8d"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: searchField.text !== "" ? "Try a different search" : "Click '+ Add seance' to get started"
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
                    id: seanceListView
                    anchors.fill: parent
                    spacing: 15
                    model: filteredModel

                    delegate: SeanceCard {
                        width: seanceListView.width
                        seanceId: model.id
                        seanceName: model.name
                        exerciseList: model.exerciselist
                        warmUp: model.warmup
                        notes: model.notes
                        createdAt: model.created_at

                        onEditClicked: function(id) {
                            root.editSeance(id)
                        }

                        onDeleteClicked: function(id) {
                            deleteConfirmDialog.seanceIdToDelete = id
                            deleteConfirmDialog.visible = true
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: filteredModel
    }

    // Delete a seance of the list
    Rectangle {
        id: deleteConfirmDialog
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        visible: false
        z: 1000

        property int seanceIdToDelete: -1

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
                    text: "Delete Seance?"
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
                                root.deleteSeance(deleteConfirmDialog.seanceIdToDelete)
                                deleteConfirmDialog.visible = false
                            }
                        }
                    }
                }
            }
        }
    }

    // Functions
    function loadSeances() {
        if (root.userId <= 0) {
            console.log("No userId set, cannot load seances")
            return
        }

        console.log("Loading seances for userId:", root.userId)
        root.seances = DatabaseManager.getSeanceByUser(root.userId)
        console.log("Loaded seances:", root.seances.length)
        filterSeances()
    }

    function filterSeances() {
        filteredModel.clear()

        var searchText = searchField.text.toLowerCase()

        for (var i = 0; i < root.seances.length; i++) {
            var seance = root.seances[i]

            if (searchText !== "") {
                var nameMatch = seance.name.toLowerCase().includes(searchText)
                var exerciseMatch = seance.exerciselist.toLowerCase().includes(searchText)
                var notesMatch = seance.notes.toLowerCase().includes(searchText)

                if (!nameMatch && !exerciseMatch && !notesMatch) {
                    continue
                }
            }

            filteredModel.append(seance)
        }
    }

    // Public function for recharging from outside
    function refresh() {
        loadSeances()
    }
}
