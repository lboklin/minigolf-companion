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

    property string playerColor: "transparent"
    property string playerName: qsTr("Player Name")

    property alias buttonItem: cardButton.data
    property url buttonIcon
    property color buttonIconColor

    property alias colorItem: colorSquare.data

    property alias nameItem: nameField.data

    // Rightmost button is pressed
    signal buttonPressed()
    // Player is finished editing
    signal finished()
    // All actions have been taken - free to clear contents
    signal done()

    onPlayerNameChanged: nameField.text = playerName

    onFinished: playerName = nameField.displayText
    onDone: nameField.clearField()

    activeFocusOnTab: false

    color: Material.background
    radius: 4
    layer { enabled: true; effect: ElevationEffect { elevation: 1 } }

    width: Math.max(200, Math.min(Window.width * 0.8, 400))
    height: 50
    
    ComboBox {
        id: colorSquare

        activeFocusOnTab: false
        displayText: ""
        width: height
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }

        model:  [ Material.color(Material.Red),
                Material.color(Material.Blue),
                Material.color(Material.Green),
                Material.color(Material.Amber),
                Material.color(Material.Purple) ]

        // The individual colored squares in the popup menu
        delegate: Rectangle {
            radius: 0
            anchors.margins: 0
            width: player.height
            height: width
            color: modelData
            clip: true

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    playerColor = modelData
                    colorSquare.activated(index)
                    colorSquare.currentIndex = index
                    colorSquare.popup.close()
                }
            }
        }

        // The appearance of the colored square
        indicator: Rectangle {

            color: playerColor

            radius: 4
            width: height + radius
            anchors.fill: parent

            // Fills in the square's right side to cover the rounded corners with nice sharp ones
            Rectangle {
                color: parent.color
                height: parent.height
                width: parent.radius
                anchors.right: parent.right
            }
        }
    }
    
    /*
    Text {
        id: displayName

        text: playerName
        font.pixelSize: 18
        color: Material.foreground
        padding: 8

        anchors {
            left: colorSquare.right
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
        verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignLeft
    }
    */

    TextField {
        id: nameField

        signal clearField()

        onEditingFinished: {
            player.finished()
        }

        onClearField: {
            placeholderText = qsTr("Player Name")
            clear()
        }

        activeFocusOnTab: parent.activeFocusOnTab
        color: Material.foreground
        //: This is the placeholderText for player name input field.
        placeholderText: player.playerName
        validator: RegExpValidator { regExp: (/[A-Öa-ö0-9 ]+/) }
        anchors {
            top: parent.top
            topMargin: 7
            left: colorSquare.right
            leftMargin: 10
            right: separator.left
            bottom: parent.bottom
        }

        background: Rectangle {
            anchors.fill: parent
            color: "transparent"
        }
    }

    // A nice little separator
    Rectangle {
        id: separator

        color: "black"
        opacity: 0.1
        width: 1
        anchors {
            top: parent.top
            right: cardButton.left
            bottom: parent.bottom
        }

    }
    
    // Rightmost button that has the functionality for starting or ending
    // editing of the contents of the parent item.
    Button {
        id: cardButton

        onClicked: buttonPressed()
        
        activeFocusOnTab: false
        enabled: nameField.acceptableInput
        flat: true
        width: 50
        height: implicitWidth
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }

        contentItem: Icon {
            source: buttonIcon
            color: buttonIconColor
            pixelSize: 24
        }
    }

    function newColor(index) {
        // Cycle through an array of colors and assign it to players
        var colors = colorSquare.model;
        index = index % (colors.length - 1)
        var color = colors[index]

        return color;
    }
}
