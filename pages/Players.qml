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

//        Component.onCompleted: { deleteAllPlayers(); /* For dev purposes */ }

        currentIndex: playerListModel.count - 1

        //This prevents the children items popping in and out as they disappear.
        displayMarginBeginning: 50; displayMarginEnd: displayMarginBeginning
        footerPositioning: ListView.OverlayFooter

        spacing: 20
        anchors { margins: 20; fill: parent }

        // A card-looking element which holds the player details
        delegate: PlayerCard {
            id: player

            // TODO: Modify the player's database entry to reflect the changes
            // made on existing player card

            Component.onCompleted: nameItem.text = playerName

            playerColor: model.color
            playerName: model.name
            playerInitials: model.initials
            buttonIcon: "qrc:/images/icons/trash.svg"

            onButtonPressed: {
                playerList.deletePlayer(model.id, index)
            }
        }

        // Populated from an sqlite database
        model: ListModel {
            id: playerListModel

            Component.onCompleted: getPlayers()

            // This is only used when first loading the page
            function getPlayers() {
                var db = LocalStorage.openDatabaseSync("mgc", "1.0", "Holds players and their details");

                db.transaction (function(tx) {
                    // Create db if it doesn't already exist
                    tx.executeSql('CREATE TABLE IF NOT EXISTS players(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, INITIALS TEXT, COLOR TEXT)');
                    var rs = tx.executeSql('SELECT * FROM players');

                    for (var i = 0; i < rs.rows.length; i++) {
                        append({
                                   id:      rs.rows.item(i).ID,
                                   name:        rs.rows.item(i).NAME,
                                   initials:    rs.rows.item(i).INITIALS,
                                   color:       rs.rows.item(i).COLOR })
                    }
                });
            }
        }

        ListViewBackground { }

        ScrollIndicator.vertical: ScrollIndicator {
            anchors {
                right: parent.right
                margins: -12
            }
        }

        function deleteAllPlayers(name, color) {
            var db = LocalStorage.openDatabaseSync("mgc", "1.0", "Holds players and their details");
            db.transaction ( function(tx) { tx.executeSql('DROP TABLE players') });
        }

        // id = player id
        // index = current index in the listview model
        function deletePlayer(id, index) {

            console.log("(#%1) %2 is dead.".arg(id).arg(playerList.model.get(index).initials));

            // Remove from listview first for them responsivenessess (Does it work?)
            playerList.model.remove(index);

            var db = LocalStorage.openDatabaseSync("mgc", "1.0", "Holds players and their details");

            db.transaction(
                        function (tx) {
                            tx.executeSql('DELETE FROM players WHERE ID=?', id)

                            var rs = tx.executeSql('SELECT * FROM players');
//                            for (var i = 0; i < rs.rows.length; i++) {
//                                console.log("(#%1) %2 is still in the game.".arg(rs.rows.item(i).ID).arg(rs.rows.item(i).INITIALS))
//                            }
                        });
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
                bottom: parent.bottom
                bottomMargin: -7
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
                    color: window.foregroundColor
                    font.pixelSize: 16

                }

                PlayerCard {
                    id: newPlayerCard

                    Component.onCompleted: playerColor = newPlayerCard.newColor(playerList.count)

                    onButtonPressed: finished()
                    onFinished: if (goodName) { addPlayer() }

                    // TODO: Something else is stealing focus. Help
                    buttonIcon: "qrc:/images/icons/done.svg"
                    anchors {
                        left: parent.left
                        leftMargin: 10
                        right: parent.right
                        rightMargin: 10
                        top: instruction.bottom
                    }

                    function addPlayer() {
                        // count + 1 because we are adding one to the existing list in both db and playerList
                        var id = 0;
                        var name = newPlayerCard.playerName.trim();
                        var initials = "";

                        // Produce initials out of displayname
                        var initialsList = name.match(/((^|[^\wåäö])[\wåäö]|\d{1,3})/gi);
                        // Concat to a single string and trim to get rid of spaces
                        for (var i = 0; i < initialsList.length; i++) { initials = initials.concat(initialsList[i].trim()) }
                        // Limit max length of initials
                        initials = initials.slice(0,4);

                        var color = newPlayerCard.playerColor;

                        var db = LocalStorage.openDatabaseSync("mgc", "1.0", "Holds players and their details");

                        // TODO: Remove all the console logging before sometime in the future - it's for debugging purposes
                        db.transaction (function(tx) {
                            // Create db if it doesn't already exist
                            tx.executeSql('CREATE TABLE IF NOT EXISTS players(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, INITIALS TEXT, COLOR TEXT)');

                            // List all players
                            var rs = tx.executeSql('SELECT * FROM players');
                            console.log("-------------");
                            for (var i = 0; i < rs.rows.length; i++) {
                                console.log("(#%2) %1 reporting in.".arg(rs.rows.item(i).INITIALS).arg(rs.rows.item(i).ID));
                            }

                            // Insert the new player
                            tx.executeSql('INSERT INTO players (NAME, INITIALS, COLOR) VALUES(?, ?, ?)', [name, initials, color]);

                            // Get the recently assigned ID -- Surely there must be a better way?
                            var ids = tx.executeSql('SELECT ID FROM players WHERE NAME=? AND COLOR=?', [name, color]);
                            id = ids.rows.item(0).ID;
                            // Print something about the new insertion
                            console.log("(#%2) %1 joined the game.".arg(initials).arg(id))
//                            console.log("The ID assigned was: %1".arg(id));
                        });

                        // Add the player to the listView model
                        playerList.model.append({"id": id, "name": name, "initials": initials, "color": color});

                        done()
                        playerColor = newPlayerCard.newColor(playerList.count)
                    }
                }
            }
        }
    }
}
