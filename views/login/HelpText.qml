import QtQuick 2.15

Text {
    id: root

    // Propiedades personalizables
    property string helpText: "Help text"
    property color textColor: "#6C63FF"
    property int fontSize: 14

    // Señales
    signal clicked()

    // Configuración del texto
    text: helpText
    color: textColor
    font.pixelSize: fontSize

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            root.clicked()
        }
    }
}
