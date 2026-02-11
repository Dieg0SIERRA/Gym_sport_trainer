import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    property var noteData: ({})

    // DEPRECATED: maintain for compatibility
    property var highlightedDates: []
    property var notes: ({})

    property color highlightColor: "#1E90FF"
    property color todayColor: "#FF6B6B"
    property color backgroundColor: "white"
    property date currentDate: new Date()

    property int currentMonth: currentDate.getMonth()
    property int currentYear: currentDate.getFullYear()
    property date today: new Date()

    signal dateClicked(date clickedDate, string existingNote, string existingColor)
    signal noteUpdated(date noteDate, string text, string color)

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
                font.pixelSize: 32
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
                font.pixelSize: 40
                font.weight: Font.Bold
                color: "#2c3e50"
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "▶"
                font.pixelSize: 32
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
            columnSpacing: 4
            rowSpacing: 4

            Repeater {
                model: ["L", "M", "X", "J", "V", "S", "D"]

                Text {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 30
                    text: modelData
                    font.pixelSize: 30
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
            columnSpacing: 4
            rowSpacing: 4

            Repeater {
                id: daysRepeater
                model: 42 // 6 weeks maximum

                Rectangle {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40

                    property int dayNumber: getDayNumber(index)
                    property bool isCurrentMonth: dayNumber > 0
                    property bool isToday: isCurrentMonth && dayNumber === today.getDate() &&
                                          currentMonth === today.getMonth() &&
                                          currentYear === today.getFullYear()
                    property string dateString: getDateString(dayNumber)

                    property bool hasNote: noteData.hasOwnProperty(dateString)
                    property string noteText: hasNote ? noteData[dateString].text : ""
                    property string noteColor: hasNote ? noteData[dateString].color : highlightColor

                    //Colour based on custom noteColour
                    color: isToday ? todayColor :
                           hasNote ? noteColor :
                           "transparent"
                    radius: 10
                    opacity: isCurrentMonth ? 1.0 : 0.3

                    Text {
                        anchors.centerIn: parent
                        text: dayNumber > 0 ? dayNumber : ""
                        font.pixelSize: 24
                        color: (parent.isToday || parent.hasNote) ? "white" : "#2c3e50"
                        font.weight: parent.isToday ? Font.Bold : Font.Normal
                    }

                    // Note indicator - use noteColor
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: parent.isToday ? "white" : parent.noteColor
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: parent.hasNote && parent.isCurrentMonth && !parent.isToday
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: parent.isCurrentMonth ? Qt.PointingHandCursor : Qt.ArrowCursor
                        enabled: parent.isCurrentMonth
                        hoverEnabled: true

                        onPositionChanged: (mouse) => {
                            if (parent.hasNote) {
                                tooltip.text = parent.noteText
                                tooltip.backgroundColor = parent.noteColor
                                tooltip.x = mouse.x + parent.x + 10
                                tooltip.y = mouse.y + parent.y - tooltip.height - 10
                                tooltip.visible = true
                            }
                        }

                        onExited: tooltip.visible = false

                        onClicked: {
                            if (parent.isCurrentMonth)
                            {
                                var clickedDate = new Date(currentYear, currentMonth, parent.dayNumber)
                                dateClicked(clickedDate, parent.noteText, parent.noteColor)
                            }
                        }
                    }
                }
            }
        }
    }

    // Tooltip for notes - dynamic color
    Rectangle {
        id: tooltip
        visible: false
        width: tooltipText.width + 20
        height: tooltipText.height + 16
        radius: 10
        z: 100

        property alias text: tooltipText.text
        property color backgroundColor: "#3bd1c7"

        color: backgroundColor

        Text {
            id: tooltipText
            anchors.centerIn: parent
            color: "white"
            font.family: "Comic Sans MS"
            font.weight: Font.DemiBold
            font.pixelSize: 30
            padding: 4
        }
    }

    function setNote(date, text, color)
    {
        var dateStr = getDateStringFromDate(date)

        var newNoteData = Object.assign({}, noteData)

        if (text.trim() === "") {
            delete newNoteData[dateStr]
        }
        else {
            newNoteData[dateStr] = { text: text,  color: color }
        }

        noteData = newNoteData
        updateCalendar()
        noteUpdated(date, text, color)      // Emit signal
    }

    function getMonthName(month) {
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return months[month]
    }

    function getDayNumber(index) {
        var firstDay = new Date(currentYear, currentMonth, 1).getDay()
        firstDay = (firstDay === 0) ? 6 : firstDay - 1 // Set monday as index 0

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

    function getDateStringFromDate(date) {
        var year = date.getFullYear()
        var month = (date.getMonth() + 1).toString().padStart(2, '0')
        var day = date.getDate().toString().padStart(2, '0')
        return year + "-" + month + "-" + day
    }

    function updateCalendar() {
        daysRepeater.model = 0
        daysRepeater.model = 42
    }

    Component.onCompleted: {
        updateCalendar()
    }
}
