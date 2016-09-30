import QtQuick 2.7
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Material.impl 2.0

//This is a Material background meant for listviews.
//The notable thing about this component
//is that it stays with the content as it scrolls.
Rectangle {
    property int bgPadding: parent.spacing * 2

    x: -parent.contentX - (bgPadding / 2)
    y: -parent.contentY - (bgPadding / 2)
    z: -1
    width: parent.width + bgPadding
    height: parent.contentHeight + bgPadding

    radius: 6
    color: Material.background
    layer { enabled: true; effect: ElevationEffect { elevation: 8 } }
}
