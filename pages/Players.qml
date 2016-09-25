import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Material.impl 2.0
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0
import "qrc:/Components"

Page {
    id: page

    //: The title of the page.
    title: qsTr("Players")

    background: Rectangle { color: Qt.darker(Material.background, 1.02) }
    /* This list starts with one element which asks the user to input their details
    ** and it will be populated as players are added. */
    ListView {
        id: playerList

        property string dateString: new Date().toLocaleDateString(Qt.locale(), "yy-MM-dd")

        signal hasPlayersChanged(bool hasPlayer)

        Component.onCompleted: {
            removePlayersTable(); // For dev purposes
        }

        //This prevents the children items popping in and out as they disappear.
        displayMarginBeginning: 50; displayMarginEnd: displayMarginBeginning

        spacing: 10
        anchors { margins: 20; fill: parent }

        // A card-looking element which holds the player details
        delegate: Rectangle {
            id: player

            Component.onCompleted: {
                playerList.currentIndex = playerListModel.count - 1
                forceActiveFocus(playerList.currentItem)
            }

            radius: 3
            layer { enabled: true; effect: ElevationEffect { elevation: 1 } }

            width: Math.max(200, Math.min(Window.width * 0.8, 400))
            height: Math.max(displayName.height * 2, Math.min(Window.height / 6, 50))

            Rectangle {
                id: colorIndicator

                radius: 3
                color: model.color

                anchors {
                    top: parent.top
                    left: parent.left
                    bottom: parent.bottom
                }
                width: height
                //                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: displayName

                text: name
                color: Material.foreground
                padding: 8

                anchors {
                    left: colorIndicator.right
                    verticalCenter: parent.verticalCenter
                }
                verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignLeft
            }
        }

        model: ListModel {
            id: playerListModel

            Component.onCompleted: getPlayers()

            function getPlayers() {
                var db = LocalStorage.openDatabaseSync("mgc", "1.0", "Holds players and their details");

                db.transaction (
                            function(tx) {
                                // Create db if it doesn't already exist
                                tx.executeSql('CREATE TABLE IF NOT EXISTS players(
                                ID          INTEGER PRIMARY KEY,
                                NAME        TEXT,
                                COLOR       TEXT)');
                                var rs = tx.executeSql('SELECT NAME, COLOR FROM players');

                                for (var i = 0; i < rs.rows.length; i++) {
                                    append( {
                                                               player: rs.rows.item(i).ID,
                                                               name: rs.rows.item(i).NAME,
                                                               color: rs.rows.item(i).COLOR } )
                                }

                                // For dev
                                if (count === 0) {
                                    append({ "player": 1, "name": "No One", "color": "red" })
                                }
                            }
                            );
            }
        }

        // Here you add players or go to next page
        footer: Rectangle {
            layer {
                enabled: true
                effect: ElevationEffect { elevation: 1 }
            }

            ColumnLayout {
                RowLayout {
                    id: newPlayer


                    spacing: 20

                    TextField {
                        id: nameField

                        onEditingFinished: {
                            if (playerListModel.count === playerList.currentIndex + 1) {
                                // TODO: either convert currentColor into a string or store it as an appropriate type in db
                                addPlayer(playerList.count + 1, displayText, colorChooser.currentColor)
                            }
                        }

                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Layout.leftMargin: 16
                        Layout.preferredHeight: Math.max(Math.min(Screen.height / 14, Window.height / 5), 50)

                        color: Material.foreground
                        //: This is the placeholderText for player name input field.
                        placeholderText: qsTr("Player Name")
                        validator: RegExpValidator { regExp: (/[A-Öa-ö0-9 ]+/) }

                        function addPlayer(index, name, color) {

                            var db = LocalStorage.openDatabaseSync("mgc", "1.0", "Holds players and their details");

                            db.transaction (
                                        function(tx) {
                                            // Create db if it doesn't already exist
                                            tx.executeSql('CREATE TABLE IF NOT EXISTS players(
                                                            ID          INTEGER PRIMARY KEY,
                                                            NAME        TEXT,
                                                            COLOR       BLOB)');

                                                tx.executeSql('INSERT INTO players VALUES(?, ?, ?)', [index, name, color]);
                                            }
                                            );
                                playerListModel.append({"player": index, "name": name, "color": color});
                            }
                        }

                        ComboBox {
                            id: colorChooser

                            property color currentColor: Material.color(Material.Red)

                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.rightMargin: 16
                            Layout.preferredHeight: nameField.height
                            Layout.preferredWidth: nameField.height

                            activeFocusOnTab: false
                            displayText: ""
                            padding: 2

                            model:  [ Material.Red, Material.Blue, Material.Green, Material.Amber, Material.Purple ]

                            popup: Popup {
                                height: contentHeight
                                width: colorChooser.width

                                contentItem: ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                Repeater {
                                    height: colorChooser.height
                                    anchors { left: parent.left; right: parent.right }

                                    delegate: Rectangle { radius: 3; color: Material.color(modelData) }

                                    model: colorChooser.model
                                }
                            }

                            //                        background: Rectangle { color: "transparent" }
                        }

                        contentItem: Rectangle {
                            radius: 3
                            color: assignColor(playerList.count + 1)
                            layer {
                                enabled: true
                                effect: ElevationEffect { elevation: 1 }
                            }

                            function assignColor(index) {
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
                }

                Button {
                    id: doneButton

                    enabled: playerList.count > 0 ? true : false
                    flat: true
                    //: This is the label on the button to finish adding players and go to next page.
                    text: qsTr("Done")
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }

                    onPressed: { stackView.push("qrc:/pages/Overview.qml") }
                }

            }
        }

        ListViewBackground { }

        ScrollIndicator.vertical: ScrollIndicator {
            anchors {
                right: parent.right
                margins: -12
            }
        }

        // TODO: Make work
        function removePlayersTable(name, color) {
            var db = LocalStorage.openDatabaseSync("mgc", "1.0", "Holds players and their details");

            db.transaction (
                        function(tx) {
                            tx.executeSql('DROP TABLE IF EXISTS players');
                        }
                        );
        }

    }
}
