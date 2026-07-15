pragma ComponentBehavior: Bound
pragma Translator: "GalleryPage"
import QtQuick
import QtQml.Models
import SwbControls

Rectangle {
    id: featured

    property bool active: true
    property int autoPlayInterval: 4000
    property int transitionDuration: 600

    implicitHeight: Math.min(340, Math.max(260, width * 0.34))
    color: SwbTheme.popover
    radius: SwbTheme.radius
    border.color: SwbTheme.border
    border.width: 1
    clip: true

    ListModel {
        id: featuredModel

        ListElement { imageSource: "assets/huawei.jpg"; tagText: QT_TR_NOOP("Limited Offer"); titleText: QT_TR_NOOP("HiSilicon Kirin Processors") }
        ListElement { imageSource: "assets/nvidia.jpg"; tagText: QT_TR_NOOP("Featured"); titleText: QT_TR_NOOP("NVIDIA Graphics Cards") }
        ListElement { imageSource: "assets/openai.jpg"; tagText: QT_TR_NOOP("Trending"); titleText: QT_TR_NOOP("OpenAI Technologies") }
        ListElement { imageSource: "assets/wechat.jpg"; tagText: QT_TR_NOOP("Recommended"); titleText: QT_TR_NOOP("WeChat Platform") }
        ListElement { imageSource: "assets/grok.jpg"; tagText: QT_TR_NOOP("New"); titleText: QT_TR_NOOP("Grok Assistant") }
    }

    Timer {
        interval: featured.autoPlayInterval
        repeat: true
        running: featured.active && featured.visible && carousel.count > 1
        onTriggered: carousel.moveToIndex((carousel.currentIndex + 1) % carousel.count, true)
    }

    ListView {
        id: carousel

        readonly property real cardWidth: Math.max(0, Math.min(width, Math.max(320, width * 0.72)))
        readonly property real cardStep: cardWidth + spacing

        function targetContentX(index) {
            const centeredOffset = index * cardStep - (width - cardWidth) / 2
            return Math.max(0, Math.min(centeredOffset, Math.max(0, contentWidth - width)))
        }

        function moveToIndex(index, animated) {
            if (count <= 0 || width <= 0)
                return

            const boundedIndex = Math.max(0, Math.min(index, count - 1))
            const targetX = targetContentX(boundedIndex)
            currentIndex = boundedIndex
            carouselMove.stop()

            if (animated) {
                carouselMove.from = contentX
                carouselMove.to = targetX
                carouselMove.start()
            } else {
                contentX = targetX
            }
        }

        function alignCurrentItem() {
            moveToIndex(currentIndex, false)
        }

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: carouselIndicator.top
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 8
        orientation: ListView.Horizontal
        model: featuredModel
        spacing: 14
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        cacheBuffer: Math.max(0, width * 2)

        onWidthChanged: Qt.callLater(alignCurrentItem)
        onContentWidthChanged: Qt.callLater(alignCurrentItem)
        onMovementStarted: carouselMove.stop()
        onMovementEnded: {
            const centeredIndex = Math.round((contentX + (width - cardWidth) / 2) / cardStep)
            moveToIndex(centeredIndex, true)
        }

        NumberAnimation {
            id: carouselMove

            target: carousel
            property: "contentX"
            duration: featured.transitionDuration
            easing.type: Easing.InOutCubic
        }

        delegate: Item {
            id: slide

            required property string imageSource
            required property string tagText
            required property string titleText

            width: carousel.cardWidth
            height: carousel.height
            // Cache the static card so vertical scrolling only composites one texture.
            layer.enabled: true

            RoundImage {
                anchors.fill: parent
                radius: SwbTheme.radiusSm
                source: slide.imageSource
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: parent.height * 0.55
                bottomLeftRadius: SwbTheme.radiusSm
                bottomRightRadius: SwbTheme.radiusSm
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 1.0; color: "#a6000000" }
                }
            }

            Rectangle {
                x: 14
                y: 14
                width: slideTag.implicitWidth + 20
                height: slideTag.implicitHeight + 10
                radius: SwbTheme.radiusSm
                color: SwbTheme.primary

                Text {
                    id: slideTag

                    anchors.centerIn: parent
                    text: qsTr(slide.tagText)
                    color: SwbTheme.primaryForeground
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                }
            }

            Column {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 16
                anchors.bottomMargin: 14
                spacing: 6

                Text {
                    text: qsTr(slide.titleText)
                    color: "#ffffff"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }

                Text {
                    text: qsTr("› Learn more")
                    color: "#e5ffffff"
                    font.pixelSize: 12
                }
            }
        }
    }

    SwbPageIndicator {
        id: carouselIndicator

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 6
        count: carousel.count
        currentIndex: carousel.currentIndex
        onCurrentIndexChanged: {
            if (carousel.currentIndex !== currentIndex)
                carousel.moveToIndex(currentIndex, true)
        }
    }
}
