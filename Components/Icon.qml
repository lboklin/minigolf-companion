import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0

Item {
    property url source
    property color color: "black"
    property int pixelSize: 32

    opacity: parent.enabled ? 0.54 : 0.1

    Image {
        id: icon

        visible: false
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectCrop
        mipmap: true
        sourceSize.height: parent.pixelSize
        source: parent.source
        smooth: true
    }

    Rectangle {
        id: iconColor

        visible: false
        anchors.fill: icon
        color: parent.color
    }

    OpacityMask {
        anchors.fill: icon
        maskSource: icon
        source: iconColor
        cached: true
    }
}
