import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root

    // Customizables properties
    property string text:         "Button"      // values: "topLeft", "topRight", "bottomLeft", "bottomRight", "center"
    property real margin:         20            // margin from the borders
    property string position:     "center"
    property color normalColor:   "#6C63FF"
    property color hoverColor:    "#7B73FF"
    property color pressedColor:  "#5A52E8"
    property color disabledColor: "#404040"
    property color textColor:     "#ffffff"
    property int fontSize: 14
    property bool enabled: true
    property real buttonRadius: 8

    // Signals
    signal clicked()

    // Calculated properties
    width: 100
    height: 40
    radius: buttonRadius
    color: !enabled ? disabledColor :
           mouseArea.pressed ? pressedColor :
           mouseArea.containsMouse ? hoverColor : normalColor
    opacity: enabled ? 1.0 : 0.6

    // Animations
    Behavior on color   { ColorAnimation  { duration: 150 } }
    Behavior on opacity { NumberAnimation { duration: 150 } }

    // brightness effect
    Rectangle {
        width: parent.width
        height: parent.height / 2
        anchors.top: parent.top
        color: "#ffffff"
        opacity: root.enabled ? 0.1 : 0.05
        radius: parent.radius
    }

    // Text of the button
    Text {
        anchors.centerIn: parent
        text: root.text
        color: root.textColor
        font.pixelSize: root.fontSize
        font.weight: Font.DemiBold
    }

    // Área of the mouse
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.enabled
        cursorShape:  root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled:      root.enabled

        onClicked: {
            if (root.enabled)
                root.clicked()
        }
    }
}
