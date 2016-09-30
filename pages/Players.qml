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

        Component.onCompleted: { removePlayersTable(); /* For dev purposes */ }

        currentIndex: playerListModel.count - 1

        //This prevents the children items popping in and out as they disappear.
        displayMarginBeginning: 50; displayMarginEnd: displayMarginBeginning
        footerPositioning: ListView.OverlayFooter

        spacing: 20
        anchors { margins: 20; fill: parent }

        // A card-looking element which holds the player details
        delegate: PlayerCard {
            id: player

            Component.onCompleted: nameItem.text = playerName

            playerColor: model.color
            playerName: model.name
            buttonIcon: "qrc:/images/icons/trash.svg"
        }

        // Populated from an sqlite database
        model: ListModel {
            id: playerListModel

            Component.onCompleted: getPlayers()

            // This is only used when first loading the page
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
                                    append({ "player": 1, "name": "No One", "color": "transparent" })
                                }
                            }
                            );
            }
        }

        ListViewBackground { }

        ScrollIndicator.vertical: ScrollIndicator {
            anchors {
                right: parent.right
                margins: -12
            }
        }

        function removePlayersTable(name, color) {
            var db = LocalStorage.openDatabaseSync("mgc", "1.0", "Holds players and their details");

            db.transaction (
                        function(tx) {
                            tx.executeSql('DROP TABLE players');
                        }
                        );
        }

    }


    footer: ColumnLayout {
        anchors {
            left: page.left
            bottom: page.bottom
            right: page.right
        }

        // Here you add players or go to next page
        Rectangle {
            id: newPlayerPanel

            color: Material.background
            height: newPlayerCard.height + instruction.height + 20
            radius: 6
            anchors {
                left: parent.left
                bottom: bottomBar.top
                right: parent.right
            }

            layer { enabled: true; effect: ElevationEffect { elevation: 8 } }

            ColumnLayout {
                spacing: 0

                anchors {
                    left: parent.left
                    right: parent.right
                }

                Text {
                    id: instruction

                    padding: 10
                    text: "Add Player:"
                    font.pixelSize: 14

                }

                PlayerCard {
                    id: newPlayerCard

                    Component.onCompleted: { playerColor = newPlayerCard.newColor(playerList.count) }

                    onButtonPressed: { finished() }
                    onFinished: {
//                        if (nameItem.acceptableInput) {
                            addPlayer()
//                        }
                    }

                    // TODO: Something else is stealing focus. This does nothing. Help
//                    activeFocusOnTab: true
//                    focus: true
                    buttonIcon: "qrc:/images/icons/done.svg"
                    anchors {
                        left: parent.left
                        leftMargin: 10
                        right: parent.right
                        rightMargin: 10
                        top: instruction.bottom
                    }

                    /*
                    nameItem: TextField {
                        id: nameField

                        signal clearField()

                        onClearField: {
                            selectAll()
                            remove(selectionStart, selectionEnd)
                            deselect()
                        }

                        onAccepted: {
                            newPlayerCard.addPlayer()
                        }

                        anchors {
                            top: parent.top
                            left: colorSquare.right
                            leftMargin: 100
                            verticalCenterOffset: 5
                            bottom: parent.bottom
                        }

                        color: Material.foreground
                        //: This is the placeholderText for player name input field.
                        placeholderText: qsTr("Player Name")
                        validator: RegExpValidator { regExp: (/[A-Öa-ö0-9 ]+/) }

                    }
                    */

                    function addPlayer() {
                        var index = playerListModel.count + 2;
                        var name = newPlayerCard.playerName;
                        var color = newPlayerCard.playerColor

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

                        done()
                        playerColor = newPlayerCard.newColor(playerList.count)
                    }
                }
            }
        }

        ToolBar {
            id: bottomBar

            anchors {
                left: parent.left
                bottom: parent.bottom
                right: parent.right
            }

            FlatButton {
                id: doneButton

                onPressed: { stackView.push("qrc:/pages/Overview.qml") }

                enabled: playerList.count > 0 ? true : false
                //: This is the label on the button to finish adding players and go to next page.
                text: qsTr("Done")

                anchors.right: parent.right
            }
        }
    }
}
