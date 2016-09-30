import QtQuick 2.0
import QtQuick.Controls 2.0

Button {
    flat: true

    contentItem: Text {
        text: parent.text
        font.pixelSize: 18
        color: window.foregroundColor
        opacity: parent.enabled ? 1.0 : 0.54
    }
}
