import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: dashboard
    color: "#ecf0f1"

    property string currentSection: "home"

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "Section: " + dashboard.currentSection.toUpperCase()
            font.pixelSize: 24
            font.weight: Font.Bold
            color: "#2c3e50"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "some dashboard content"
            font.pixelSize: 16
            color: "#7f8c8d"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Repeater {
                model: ListModel {
                    ListElement { label: "Add seance"; icon: "➕" }
                    ListElement { label: "Add exercise"; icon: "➕" }
                    ListElement { label: "Add program"; icon: "➕" }
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
                ListElement { title: "Time in gym"; value: "3h 20min"; icon: "⏱️" }
                ListElement { title: "Time running"; value: "12 km"; icon: "🏃" }
                ListElement { title: "Calories burned"; value: "550 kcal"; icon: "🔥" }
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


