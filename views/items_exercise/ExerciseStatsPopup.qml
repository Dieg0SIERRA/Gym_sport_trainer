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

    property int templateId: -1
    property string templateName: ""
    property var variations: []

    signal cancelled()

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.visible = false
            root.cancelled()
        }
    }

    Rectangle {
        width: 600
        height: 650
        anchors.centerIn: parent
        color: "#2a2a2a"
        radius: 20
        border.width: 2
        border.color: "#6C63FF"

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 25
            spacing: 15

            // Title
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "📈 Progress: " + root.templateName
                color: "#ffffff"
                font.pixelSize: 22
                font.weight: Font.Bold
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#6C63FF"
                opacity: 0.3
            }

            // Summary section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: "#1a1a1a"
                radius: 12
                border.width: 1
                border.color: "#404040"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 8

                    Text {
                        text: "Summary"
                        color: "#6C63FF"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 4

                        Text {
                            text: "• First:"
                            color: "#b0b0b0"
                            font.pixelSize: 13
                        }

                        Text {
                            id: firstVariationText
                            text: getFirstVariationSummary()
                            color: "#ffffff"
                            font.pixelSize: 13
                        }

                        Text {
                            text: "• Latest:"
                            color: "#b0b0b0"
                            font.pixelSize: 13
                        }

                        Text {
                            id: latestVariationText
                            text: getLatestVariationSummary()
                            color: "#ffffff"
                            font.pixelSize: 13
                        }

                        Text {
                            text: "• Progress:"
                            color: "#b0b0b0"
                            font.pixelSize: 13
                        }

                        Text {
                            id: progressText
                            text: getProgressSummary()
                            color: getProgressColor()
                            font.pixelSize: 13
                            font.weight: Font.Bold
                        }
                    }
                }
            }

            // Empty state
            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                visible: root.variations.length === 0
                text: "No variations recorded yet"
                color: "#7f8c8d"
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
            }

            // Close button
            Components.GenericButton {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 120
                Layout.preferredHeight: 40
                buttonRadius: 10
                fontSize: 14
                text: "Close"
                normalColor: "#3a3a3a"
                hoverColor: "#4a4a4a"
                pressedColor: "#5a5a5a"
                onClicked: {
                    root.visible = false
                    root.cancelled()
                }
            }
        }
    }

    function show(templateIdParam, templateNameParam) {
        root.templateId = templateIdParam
        root.templateName = templateNameParam
        loadVariations()
        root.visible = true
    }

    function loadVariations() {
        if (root.templateId <= 0) return

        console.log("Loading variations for stats:", root.templateId)
        root.variations = DatabaseManager.getExerciseVariations(root.templateId)
        console.log("Loaded variations for stats:", root.variations.length)
    }

    function getFirstVariationSummary() {
        if (root.variations.length === 0) return "N/A"
        var first = root.variations[root.variations.length - 1]
        return first.weight + " kg (" + formatDate(first.created_at) + ")"
    }

    function getLatestVariationSummary() {
        if (root.variations.length === 0) return "N/A"
        var latest = root.variations[0]
        return latest.weight + " kg (" + formatDate(latest.created_at) + ")"
    }

    function getProgressSummary() {
        if (root.variations.length < 2) return "No progress data yet"

        var first = root.variations[root.variations.length - 1]
        var latest = root.variations[0]
        var diff = latest.weight - first.weight
        var percentage = first.weight > 0 ? ((diff / first.weight) * 100).toFixed(1) : 0

        var sign = diff > 0 ? "+" : ""
        var arrow = diff > 0 ? "🔼" : diff < 0 ? "🔽" : "➡️"

        return sign + diff + " kg (" + sign + percentage + "%) " + arrow
    }

    function getProgressColor() {
        if (root.variations.length < 2) return "#7f8c8d"

        var first = root.variations[root.variations.length - 1]
        var latest = root.variations[0]
        var diff = latest.weight - first.weight

        return diff > 0 ? "#27ae60" : diff < 0 ? "#e74c3c" : "#7f8c8d"
    }
    
    function formatDate(dateString) {
        if (!dateString) return ""

        var date = new Date(dateString)
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var day = date.getDate()
        var month = months[date.getMonth()]
        var year = date.getFullYear()

        return month + " " + day + ", " + year
    }
}
