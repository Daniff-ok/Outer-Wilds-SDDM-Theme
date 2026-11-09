import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 6.0

Item {
    id: root
    width: Screen.width
    height: Screen.height

    property real ratio: width / 1920

    property string realUsername: userModel.lastUser ? userModel.lastUser : (config.defaultUser || "user")

    FontLoader {
        id: isleFont
        source: "fonts/itc-serif-gothic-regular.otf"
    }

    FontLoader {
        id: itcLight
        source: "fonts/itc-serif-gothic-light.otf"
    }

    // Video Outer Wilds backgrounds
    MediaPlayer {
        id: player
        source: "backgrounds/OuterWilds_new.mkv"
        loops: MediaPlayer.Infinite
        videoOutput: videoOut
        audioOutput: AudioOutput { volume: config.videoVolume}
        Component.onCompleted: play()
    }

    VideoOutput {
        id: videoOut
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
    }

    MouseArea {
        anchors.fill: parent
        z: -1

        onClicked: {
            root.forceActiveFocus();

            Qt.inputMethod.hide();
        }
    }

    

    // Main rectangle for all
    Rectangle {
        id: uiContainer
        width: root.width * 0.25
        height: root.height * 0.7
        radius: 15
        border.color: "#3D3D3D"
        border.width: 1
        anchors.centerIn: parent
        color: "#0A0A0A"
        opacity: 0.85

        Column {
            anchors.fill: parent
            anchors.margins: 20
            anchors.topMargin: 50
            spacing: 40

            // Clock block
            Column {
                id: clockBlock
                width: parent.width
                spacing: 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20

                //Hallo Text
                Text {
                    id: helloText
                    text: "HAVE A GREAT JOURNEY!"
                    font.family: isleFont.name; font.pixelSize: 20 * ratio
                    font.letterSpacing: 10
                    color: "#FFFFFF"; opacity: 0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                //Time
                Text {
                    id: clockTime
                    text: Qt.formatTime(new Date(), "hh:mm")
                    font.family: itcLight.name; font.pixelSize: 100 * ratio
                    color: "#FFFFFF";
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                //Date
                Text {
                    id: clockDate
                    text: Qt.formatDate(new Date(), "dddd, MMMM d")
                    font.family: itcLight.name; font.pixelSize: 20 * ratio
                    color: "#FFFFFF"; opacity: 0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                //Update Timer and Date
                Timer {
                    interval: 1000; running: true; repeat: true
                    onTriggered: {
                        clockTime.text = Qt.formatTime(new Date(), "hh:mm")
                        clockDate.text = Qt.formatDate(new Date(), "dddd, MMMM d")
                    }
                }
            }

            // Auth
            Item {
                id: formBlock
                width: parent.width
                height: childrenRect.height
                z: 10

                // Login
                Item{
                    id: usernameBlock
                    anchors.top: formBlock.top
                    width: formBlock.width
                    height: childrenRect.height

                    Text {
                        id: usernameTitle
                        anchors.top: usernameBlock.top

                        text: "ASTRONAUT ID"
                        font.family: isleFont.name
                        font.pixelSize: 14 * ratio
                        color: userSelector.popup.visible ? "#FF7D25" : "#FFFFFF"
                        opacity: userSelector.popup.visible ? 1 : 0.6
                    }

                    //List of users
                    ComboBox {
                        id: userSelector
                        anchors.top: usernameTitle.bottom
                        anchors.topMargin: 5
                        width: formBlock.width

                        model: userModel
                        textRole: "name"

                        background: Rectangle {
                            opacity: 0
                        }

                        contentItem: Text {
                            id: usernameField
                            text: userSelector.displayText
                            color: userSelector.popup.visible ? "#FF7D25" : "#FFFFFF"
                            font.pixelSize: 20 * ratio
                            font.family: isleFont.name
                            opacity: userSelector.popup.visible ? 1 : 0.8
                        }

                        indicator: Text {
                            x: userSelector.width - width - 12
                            y: (userSelector.height - height) / 2
                            text: "▾" 
                            color: "#9399b2"
                            font.pixelSize: 16
                        }

                        popup: Popup {
                            y: userSelector.height + 4
                            width: userSelector.width
                            implicitHeight: Math.min(contentItem.contentHeight + 16, 300)



                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: userSelector.popup.visible ? userSelector.delegateModel : null
                                ScrollIndicator.vertical: ScrollIndicator { }
                            }

                            background: Rectangle {
                                radius: 12
                                color: "#1C1C1C"
                            }
                        }

                        delegate: ItemDelegate {
                            id: delegateItem
                            width: userSelector.width - 8
                            height: 36

                            contentItem: Text {
                                text: userSelector.textRole ? (Array.isArray(userSelector.model) ? modelData[userSelector.textRole] : model[userSelector.textRole]) : modelData
                                color: delegateItem.highlighted ? "#1e1e2e" : "#FFFFFF"
                                font.pixelSize: 14
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 12
                            }

                            background: Rectangle {
                                color: delegateItem.highlighted ? "#FF7D25" : "transparent"
                                radius: 6
                            }

                            highlighted: userSelector.highlightedIndex === index
                        }
                    }

                    Rectangle {
                        id: lineLogin
                        anchors.top: userSelector.bottom
                        height: 1
                        width: formBlock.width
                        color: "#FFFFFF"
                        opacity: 0.6
                    }
                }

                // Password
                Item {
                    id: passwordBlock
                    width: formBlock.width
                    height: childrenRect.height
                    anchors.top: usernameBlock.bottom
                    anchors.topMargin: 40

                    Text {
                        id: passwordTitle
                        anchors.top: passwordBlock.top

                        text: "INSERT LAUNCH CODE"
                        font.family: isleFont.name
                        font.pixelSize: 14 * ratio
                        color: passwordField.activeFocus ? "#FF7D25" : "#FFFFFF"
                        opacity: passwordField.activeFocus ? 1 : 0.6
                    }


                    TextField {
                        id: passwordField
                        anchors.top: passwordTitle.bottom
                        width: formBlock.width
                        height: 42

                        echoMode: TextInput.Normal
                        font.family: isleFont.name; font.pixelSize: 20 * ratio
                        color: passwordField.activeFocus ? "#FF7D25" : "#FFFFFF"
                        background: Rectangle {
                            color: "transparent"
                            border.width: 0
                        }

                        Component.onCompleted: {
                            passwordField.forceActiveFocus()
                        }   

                        property string realPassword: ""
                        property var maskSymbols: ["-", "-", "|", "-", ".", ".", "|", "-", ".", "|"]
                        property int curretLength: 0

                        onTextChanged: {

                            if (text === getMaskedText(curretLength)) return;

                            let diff = text.length - realPassword.length;
                            let cursor = cursorPosition;
                            let newLength = text.length;

                            if (newLength > curretLength) {
                                let addedChars = text.substring(cursor - diff, cursor);
                                realPassword = realPassword.substring(0, cursor - diff) + addedChars + realPassword.substring(cursor - diff);
                                curretLength += diff;
                            } else if (newLength < curretLength) {
                                let removeCount = Math.abs(diff);

                                realPassword = realPassword.substring(0, cursor) + realPassword.substring(cursor + removeCount);
                                curretLength += diff;
                            }

                            text = getMaskedText(curretLength);
                            cursorPosition = cursor;
                        }

                        function getMaskedText(length) {
                            let masked = "";
                            let curretSymbolPosition = 0;
                            for (let i = 0; i < length; i++) {
                                if (curretSymbolPosition >= maskSymbols.length) {
                                    curretSymbolPosition = 0;
                                }

                                masked += maskSymbols[curretSymbolPosition];

                                curretSymbolPosition++
                            }
                            return masked;
                        }


                        Keys.onPressed: function(event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(usernameField.text, passwordField.realPassword, sessionSelector.currentIndex)
                            }
                        }

                    }

                    Rectangle {
                        id: linePassword
                        anchors.top: passwordField.bottom
                        height: 1
                        width: formBlock.width
                        color: passwordField.activeFocus ? "#FF7D25" : "#FFFFFF"
                        opacity: passwordField.activeFocus ? 1 : 0.6
                    }
                }

                // enviroment sellect
                Item {
                    id: sessionBlock
                    width: formBlock.width
                    height: childrenRect.height
                    anchors.top: passwordBlock.bottom
                    anchors.topMargin: 40

                    Text {
                        id: enviromentTitle
                        anchors.top: sessionBlock.top

                        text: "ENVIROMENT"
                        font.family: isleFont.name
                        font.pixelSize: 14 * ratio
                        color: sessionSelector.popup.visible ? "#FF7D25" : "#FFFFFF"
                        opacity: sessionSelector.popup.visible ? 1 : 0.6
                    }

                    //List of enviroment
                    ComboBox {
                        id: sessionSelector
                        anchors.top: enviromentTitle.bottom
                        anchors.topMargin: 15
                        width: formBlock.width

                        model: sessionModel
                        textRole: "name"

                        background: Rectangle {
                            opacity: 0
                        }

                        contentItem: Text {
                            text: sessionSelector.displayText
                            color: sessionSelector.popup.visible ? "#FF7D25" : "#FFFFFF"
                            font.pixelSize: 18 * ratio
                            font.family: isleFont.name
                            opacity: sessionSelector.popup.visible ? 1 : 0.8
                        }

                        indicator: Text {
                            x: userSelector.width - width - 12
                            y: (userSelector.height - height) / 2
                            text: "▾" 
                            color: "#9399b2"
                            font.pixelSize: 16
                        }

                        popup: Popup {
                            y: sessionSelector.height + 4
                            width: sessionSelector.width
                            implicitHeight: Math.min(contentItem.contentHeight + 16, 300)



                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: sessionSelector.popup.visible ? sessionSelector.delegateModel : null
                                ScrollIndicator.vertical: ScrollIndicator { }
                            }

                            background: Rectangle {
                                radius: 12
                                color: "#1C1C1C"
                            }
                        }

                        delegate: ItemDelegate {
                            id: delegateItem
                            width: sessionSelector.width - 8
                            height: 36

                            contentItem: Text {
                                text: sessionSelector.textRole ? (Array.isArray(sessionSelector.model) ? modelData[sessionSelector.textRole] : model[sessionSelector.textRole]) : modelData
                                color: delegateItem.highlighted ? "#1e1e2e" : "#FFFFFF"
                                font.pixelSize: 14
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 12
                            }

                            background: Rectangle {
                                color: delegateItem.highlighted ? "#FF7D25" : "transparent"
                                radius: 6
                            }

                            highlighted: sessionSelector.highlightedIndex === index
                        }
                    }

                    Rectangle {
                        id: lineSessions
                        anchors.top: sessionSelector.bottom
                        anchors.topMargin: 10
                        height: 1
                        width: formBlock.width
                        color: "#FFFFFF"
                        opacity: passwordField.activeFocus ? 1 : 0.6
                    }
                }


                // LAUNCH BUTTON
                Button {
                    id: loginButton
                    anchors.top: sessionBlock.bottom
                    anchors.topMargin: 60
                    width: formBlock.width
                    height: 42

                    flat: true

                    text: "LAUNCH"
                    font.family: isleFont.name
                    font.letterSpacing: 14
                    font.pixelSize: loginButton.hovered ? 30 * ratio : 26 * ratio

                    Behavior on font.pixelSize {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }

                    font.bold: true

                    contentItem: Text {
                        text: loginButton.text
                        font: loginButton.font
                        color: "#FFFFFF"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: "transparent"
                        border.color: "#FFFFFF"
                        border.width: 1
                        opacity: 0.4
                        radius: 10
                    }

                    onClicked: { sddm.login(usernameField.text, passwordField.realPassword, sessionSelector.currentIndex) }
                }

                // Error text under launch buttom
                Text {
                    id: errorMessage
                    anchors.top: loginButton.bottom
                    anchors.topMargin: 45;
                    anchors.horizontalCenter: formBlock.horizontalCenter
                    text: ""
                    horizontalAlignment: Text.AlignHCenter
                    font.family: isleFont.name; font.pixelSize: 16
                    color: "#A53A2B"
                }
            }
        }
    }

    // Check login errors from sddm
    Connections {
        target: sddm
        function onLoginFailed() {
            errorMessage.text = "Get the launch codes at the observatory \nbefore you can lift off"
            passwordField.text = ""
            passwordField.realPassword = ""
            passwordField.curretLength = 0
            passwordField.focus = true
        }
    }
}
