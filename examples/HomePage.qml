import QtQuick
import QtMultimedia
import SwbControls

// Home page with a full-bleed video and floating project cards.
Item {
    id: home

    property bool active: true
    required property url videoSource

    // Glass card with a translucent surface, subtle border, and fixed dark text.
    component GlassCard: Rectangle {
        width: 320
        color: "#73ffffff"
        radius: 8
        border.color: "#66ffffff"
        border.width: 2
    }

    VideoOutput {
        id: backgroundVideo
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
    }

    MediaPlayer {
        id: backgroundPlayer
        source: home.videoSource
        videoOutput: backgroundVideo
        loops: MediaPlayer.Infinite
        Component.onCompleted: {
            if (home.active)
                play()
        }
    }

    onActiveChanged: active ? backgroundPlayer.play() : backgroundPlayer.pause()

    // Dim the background in dark mode to keep the page comfortable to read.
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: SwbTheme.darkMode ? 0.42 : 0
        Behavior on opacity { NumberAnimation { duration: SwbTheme.animationDuration } }
    }

    Column {
        anchors.right: parent.right
        anchors.rightMargin: 56
        anchors.verticalCenter: parent.verticalCenter
        spacing: 28

        // Repository card with an icon, description, and external link.
        GlassCard {
            height: repoBody.implicitHeight + 52

            Column {
                id: repoBody
                x: 28
                y: 26
                width: parent.width - 56
                spacing: 14

                Image {
                    source: "assets/github.svg"
                    width: 46
                    height: 46
                    sourceSize: Qt.size(92, 92)
                }

                Text {
                    text: qsTr("SWB-QML-UI GitHub")
                    color: "#1a1a1a"
                    font.pixelSize: 17
                    font.weight: Font.Bold
                }

                Text {
                    width: parent.width
                    text: qsTr("If you find this useful, consider starring the project on GitHub.")
                    color: "#26262b"
                    font.pixelSize: 13
                    lineHeight: 1.35
                    wrapMode: Text.WordWrap
                }
            }

            // Bottom-right link to the project repository.
            Canvas {
                id: goIcon
                width: 20
                height: 20
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 14
                scale: goHover.hovered ? 1.15 : 1.0
                Behavior on scale { NumberAnimation { duration: SwbTheme.animationDuration } }

                onPaint: {
                    const ctx = getContext("2d")
                    ctx.reset()
                    ctx.strokeStyle = "#1a1a1a"
                    ctx.lineWidth = 2
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"
                    ctx.beginPath()
                    ctx.moveTo(5, 15)
                    ctx.lineTo(15, 5)
                    ctx.moveTo(8, 5)
                    ctx.lineTo(15, 5)
                    ctx.lineTo(15, 12)
                    ctx.stroke()
                }

                HoverHandler {
                    id: goHover
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    onTapped: Qt.openUrlExternally("https://github.com/xxmzwf/SWB-QML-UI")
                }
            }
        }

        // Contact card with the author avatar and email address.
        GlassCard {
            height: contactBody.implicitHeight + 52

            Column {
                id: contactBody
                x: 28
                y: 26
                width: parent.width - 56
                spacing: 14

                RoundImage {
                    width: 46
                    height: 46
                    source: "assets/avatar.svg"
                }

                Text {
                    text: qsTr("SWB-QML-UI Components")
                    color: "#1a1a1a"
                    font.pixelSize: 17
                    font.weight: Font.Bold
                }

                Text {
                    text: "xxmzwf@gmail.com"
                    color: "#26262b"
                    font.pixelSize: 13
                }
            }
        }
    }
}
