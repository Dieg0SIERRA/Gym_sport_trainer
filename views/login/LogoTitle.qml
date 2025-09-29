import QtQuick 2.15

Item {
    id: root

    // Propiedades personalizables
    property string titleText: "Exercise Tracker"
    property string iconText: "💪"
    property int circleSize: 60
    property color circleColor: "#6C63FF"
    property color titleColor: "#ffffff"
    property color iconColor: "#ffffff"
    property int titleFontSize: 18
    property int iconFontSize: 28

    // Tamaño del componente
    width: circleSize
    height: circleSize + titleFontSize + 20 // círculo + espacio + texto

    // Círculo con icono
    Rectangle {
        id: circle
        width: root.circleSize
        height: root.circleSize
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.circleColor
        radius: root.circleSize / 2

        Text {
            anchors.centerIn: parent
            text: root.iconText
            color: root.iconColor
            font.pixelSize: root.iconFontSize
        }
    }

    // Texto del título
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: circle.bottom
        anchors.topMargin: 10
        text: root.titleText
        color: root.titleColor
        font.pixelSize: root.titleFontSize
        font.weight: Font.Medium
    }
}
