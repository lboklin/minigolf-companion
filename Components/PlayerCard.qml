import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Material.impl 2.0
import QtGraphicalEffects 1.0
import "qrc:/Components"

Rectangle {
    id: player

    property color playerColor: "transparent"
    property string playerName: ""
    property url iconSource
    property alias colorItem: colorSquare.data
    property alias nameItem: displayName.data
    property alias buttonItem: cardButton.data

    color: Material.background
    radius: 4
    layer { enabled: true; effect: ElevationEffect { elevation: 1 } }

    width: Math.max(200, Math.min(Window.width * 0.8, 400))
    height: 50
    
    Rectangle {
        id: colorSquare

        radius: parent.radius
        color: playerColor

        width: height + radius
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }

        // Fills in the square's right side to cover the rounded corners with nice sharp ones
        Rectangle {
            color: parent.color
            width: parent.radius
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
        }
    }

    ComboBox {
        id: colorChooser

        Component.onCompleted: { currentColor = playerColor === "transparent" ? getColor(playerList.count + 1) : "transparent" }

        property color currentColor

        width: height
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }

        activeFocusOnTab: false
        displayText: ""

        model:  [ Material.Red, Material.Blue, Material.Green, Material.Amber, Material.Purple ]

        popup: Popup {
            height: contentHeight
            width: player.height
            transformOrigin: Popup.Right

            contentItem: ColumnLayout {
                spacing: 0

                Repeater {
                    delegate: Rectangle {
                        height: colorChooser.height
                        color: Material.color(modelData)
                        width: player.height
                    }

                    model: colorChooser.model
                }
            }

            background: Rectangle { color: "transparent" }
        }

        indicator: Rectangle {

            radius: 4
            color: colorChooser.currentColor
            //                            layer { enabled: true; effect: ElevationEffect { elevation: 1 } }

            function getColor(index) {
                // Cycle through an array of colors and assign it to players
                var colors = [Material.color(Material.Red),
                              Material.color(Material.Blue),
                              Material.color(Material.Green),
                              Material.color(Material.Yellow),
                              Material.color(Material.Purple),
                              Material.color(Material.Amber)];
                index = index % colors.length

                return colors[index];
            }
        }

        background: Rectangle { color: "transparent" }

        onActivated: {
            currentColor = model[index]
        }
    }
    
    Text {
        id: displayName

        text: playerName
        font.pixelSize: 18
        color: Material.foreground
        padding: 8

        anchors {
            left: colorSquare.right
            verticalCenter: parent.verticalCenter
        }
        verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignLeft
    }

    // A nice little separator
    Rectangle {
        color: "black"
        opacity: 0.1
        width: 1
        anchors {
            top: parent.top
            right: cardButton.left
            bottom: parent.bottom
        }

    }
    
    Button {
        id: cardButton
        
        flat: true
        width: 50
        height: implicitWidth
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }

        contentItem: Icon {
            source: iconSource
            color: "black"
            pixelSize: 24
        }
    }
}
