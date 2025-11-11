import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    property var highlightedDates: [] // Array of Highlights dates: ["2025-10-15", "2025-10-20"]
    property var notes: ({}) // notes: {"2025-10-15": "training", "2025-10-20": "Break"}
    property color highlightColor: "#1E90FF"
    property color todayColor: "#FF6B6B"
    property color backgroundColor: "white"
    property date currentDate: new Date()

    property int currentMonth: currentDate.getMonth()
    property int currentYear: currentDate.getFullYear()
    property date today: new Date()
    
    // Signals
    signal dateClicked(date clickedDate)

    color: backgroundColor
    radius: 20
    border.color: "#e0e0e0"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        // Header with navigation
        RowLayout {
            Layout.fillWidth: true
            spacing: 5

            Text {
                text: "◀"
                font.pixelSize: 16
                color: "#2c3e50"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        currentMonth--
                        if (currentMonth < 0) {
                            currentMonth = 11
                            currentYear--
                        }
                        updateCalendar()
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: getMonthName(currentMonth) + " " + currentYear
                font.pixelSize: 14
                font.weight: Font.Bold
                color: "#2c3e50"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "▶"
                font.pixelSize: 16
                color: "#2c3e50"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        currentMonth++
                        if (currentMonth > 11) {
                            currentMonth = 0
                            currentYear++
                        }
                        updateCalendar()
                    }
                }
            }
        }

        // days of week
        GridLayout {
            Layout.fillWidth: true
            columns: 7
            columnSpacing: 2
            rowSpacing: 2

            Repeater {
                model: ["L", "M", "X", "J", "V", "S", "D"]

                Text {
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 15
                    text: modelData
                    font.pixelSize: 10
                    font.weight: Font.Bold
                    color: "#7f8c8d"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Grid of days
        GridLayout {
            id: daysGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 7
            columnSpacing: 2
            rowSpacing: 2

            Repeater {
                id: daysRepeater
                model: 42 // 6 weeks maximum

                Rectangle {
                    Layout.preferredWidth: 20
                    Layout.preferredHeight: 20

                    property int dayNumber: getDayNumber(index)
                    property bool isCurrentMonth: dayNumber > 0
                    property bool isToday: isCurrentMonth && dayNumber === today.getDate() &&
                                          currentMonth === today.getMonth() &&
                                          currentYear === today.getFullYear()
                    property string dateString: getDateString(dayNumber)
                    property bool isHighlighted: highlightedDates.indexOf(dateString) !== -1
                    property bool hasNote: notes.hasOwnProperty(dateString)

                    color: isToday ? todayColor :
                           isHighlighted ? highlightColor :
                           "transparent"
                    radius: 10
                    opacity: isCurrentMonth ? 1.0 : 0.3

                    Text {
                        anchors.centerIn: parent
                        text: dayNumber > 0 ? dayNumber : ""
                        font.pixelSize: 10
                        color: (parent.isToday || parent.isHighlighted) ? "white" : "#2c3e50"
                        font.weight: parent.isToday ? Font.Bold : Font.Normal
                    }

                    // Note indicator
                    Rectangle {
                        width: 4
                        height: 4
                        radius: 2
                        color: parent.isToday || parent.isHighlighted ? "white" : highlightColor
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: parent.hasNote && parent.isCurrentMonth
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: parent.isCurrentMonth ? Qt.PointingHandCursor : Qt.ArrowCursor
                        enabled: parent.isCurrentMonth
                        hoverEnabled: true

                        onEntered: (mouse) => {
                            if (parent.hasNote) {
                                tooltip.text = notes[parent.dateString]
                                tooltip.x = mouse.x + parent.x
                                tooltip.y = mouse.y + parent.y - tooltip.height - 10
                                tooltip.visible = true
                            }
                        }

                        onExited: tooltip.visible = false

                        onClicked: {
                            if (parent.isCurrentMonth) {
                                var clickedDate = new Date(currentYear, currentMonth, parent.dayNumber)
                                dateClicked(clickedDate)
                            }
                        }
                    }
                }
            }
        }
    }

    // Tooltip for notes
    Rectangle {
        id: tooltip
        visible: false
        width: tooltipText.width + 16
        height: tooltipText.height + 12
        color: "#2c3e50"
        radius: 6
        z: 100

        property alias text: tooltipText.text

        Text {
            id: tooltipText
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 10
            padding: 4
        }
    }

    function getMonthName(month) {
        var months = ["Ene", "Feb", "Mar", "Abr", "May", "Jun",
                     "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
        return months[month]
    }

    function getDayNumber(index) {
        var firstDay = new Date(currentYear, currentMonth, 1).getDay()
        firstDay = (firstDay === 0) ? 6 : firstDay - 1 // Ajustar para que lunes sea 0

        var daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate()
        var dayNum = index - firstDay + 1

        if (dayNum < 1 || dayNum > daysInMonth) {
            return -1
        }
        return dayNum
    }

    function getDateString(dayNumber) {
        if (dayNumber < 1) return ""
        var month = (currentMonth + 1).toString().padStart(2, '0')
        var day = dayNumber.toString().padStart(2, '0')
        return currentYear + "-" + month + "-" + day
    }

    function updateCalendar() {
        // Forzar actualización del repeater
        daysRepeater.model = 0
        daysRepeater.model = 42
    }

    Component.onCompleted: {
        updateCalendar()
    }
}
