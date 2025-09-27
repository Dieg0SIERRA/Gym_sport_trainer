import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    // Customizables properties
    property string labelText: "Label"
    property string placeholderText: "Enter text"
    property bool isPassword: false
    property color labelColor: "#b0b0b0"
    property color focusColor: "#6C63FF"
    property color validColor: "#40a040"
    property color errorColor: "#d04040"
    property color textColor: "#ffffff"
    property color normalBorderColor: "#404040"
    property color placeholderColor: "#666666"
    property color fieldBackgroundColor: "#2a2a2a"
    property int fontSize: 16
    property int fieldRadius: 12
    property int labelFontSize: 14
    property int messageFontSize: 12

    // Validation status
    property bool isValid: false
    property string validationMessage: ""
    property bool showValidation: false

    // exposed properties
    // readonly property alias text: textField.text
    // readonly property alias activeFocus: textField.activeFocus
    property string text: textField.text
    readonly property bool fieldHasFocus: textField.activeFocus

    // Signals
    // signal textChanged()

    // agregar binding inverso para que funcione en ambas direcciones:
    onTextChanged: {
        if (textField.text !== text)
            textField.text = text
    }

    implicitWidth: 300
    implicitHeight: 85

    // Label
    Text {
        id: label
        text: root.labelText
        color: root.labelColor
        font.pixelSize: root.labelFontSize
        font.weight: Font.Medium
    }

    // text field with background
    Rectangle {
        id: fieldBackground
        width: parent.width
        height: 50
        anchors.top: label.bottom
        anchors.topMargin: 8
        color: root.fieldBackgroundColor
        radius: root.fieldRadius
        border.width: textField.activeFocus ? 2 : 1
        border.color: root.fieldHasFocus ? root.focusColor :
                      root.showValidation ? (root.isValid ? root.validColor : root.errorColor) :
                      root.normalBorderColor

        Behavior on border.color { ColorAnimation { duration: 200 } }

        TextField {
            id: textField
            anchors.fill: parent
            anchors.margins: 15
            placeholderText: root.placeholderText
            placeholderTextColor: root.placeholderColor
            color: root.textColor
            background: Item {}
            font.pixelSize: root.fontSize
            echoMode: root.isPassword ? TextInput.Password : TextInput.Normal
            selectByMouse: true

            onTextChanged: {
                if (root.text !== text)
                    root.text = text
            }
        }
    }

    // Validation message
    Text {
        anchors.top: fieldBackground.bottom
        anchors.topMargin: 5
        text: root.validationMessage
        color: root.isValid ? root.validColor : root.errorColor
        font.pixelSize: root.messageFontSize
        visible: root.showValidation && root.validationMessage !== ""
    }
}
