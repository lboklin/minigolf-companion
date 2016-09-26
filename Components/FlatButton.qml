import QtQuick 2.0
import QtQuick.Controls 2.0

Button {
    flat: true
    //: This is the label on the button to finish adding players and go to next page.

    contentItem: Text {
        text: parent.text
        font.pixelSize: 18
        color: window.foregroundColor
        opacity: parent.enabled ? 1.0 : 0.54
    }
}
