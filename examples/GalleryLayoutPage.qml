pragma ComponentBehavior: Bound
pragma Translator: "GalleryPage"
import QtQuick
import QtQuick.Controls.Basic
import SwbControls

GalleryCategoryPage {
    id: page

    component Section: GallerySection { filterText: page.filterText }

    Section {
        title: qsTr("Pane")
        SwbPane {
            width: 280

            Column {
                width: parent.width
                spacing: 6

                SwbLabel {
                    text: qsTr("Muted panel")
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
                SwbLabel {
                    width: parent.width
                    text: qsTr("Use a pane to group related content on a flat background.")
                    color: SwbTheme.mutedForeground
                    font.weight: Font.Normal
                    wrapMode: Text.WordWrap
                }
            }
        }
    }

    Section {
        title: qsTr("Page")
        Rectangle {
            width: 300
            height: 130
            color: "transparent"
            border.color: SwbTheme.border
            border.width: 1
            radius: SwbTheme.radius
            clip: true

            SwbPage {
                anchors.fill: parent
                anchors.margins: 1

                background: Rectangle {
                    radius: Math.max(0, SwbTheme.radius - 1)
                    color: SwbTheme.background
                }

                header: Rectangle {
                    implicitHeight: 36
                    topLeftRadius: Math.max(0, SwbTheme.radius - 1)
                    topRightRadius: Math.max(0, SwbTheme.radius - 1)
                    color: SwbTheme.withAlpha(SwbTheme.secondary, 0.5)

                    SwbLabel {
                        x: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Settings")
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: SwbTheme.border
                    }
                }

                footer: Rectangle {
                    implicitHeight: 28
                    bottomLeftRadius: Math.max(0, SwbTheme.radius - 1)
                    bottomRightRadius: Math.max(0, SwbTheme.radius - 1)
                    color: SwbTheme.withAlpha(SwbTheme.secondary, 0.5)

                    SwbLabel {
                        x: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("3 items")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: 1
                        color: SwbTheme.border
                    }
                }

                SwbLabel {
                    anchors.centerIn: parent
                    text: qsTr("Page content")
                    color: SwbTheme.mutedForeground
                    font.weight: Font.Normal
                }
            }
        }
    }

    Section {
        title: qsTr("SplitView")
        Rectangle {
            width: 300
            height: 130
            color: "transparent"
            border.color: SwbTheme.border
            border.width: 1
            radius: SwbTheme.radius
            clip: true

            SwbSplitView {
                anchors.fill: parent
                anchors.margins: 1

                Rectangle {
                    SplitView.preferredWidth: 110
                    SplitView.minimumWidth: 70
                    topLeftRadius: Math.max(0, SwbTheme.radius - 1)
                    bottomLeftRadius: Math.max(0, SwbTheme.radius - 1)
                    color: SwbTheme.withAlpha(SwbTheme.secondary, 0.5)

                    SwbLabel {
                        anchors.centerIn: parent
                        text: qsTr("Navigation")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                    }
                }

                Rectangle {
                    SplitView.fillWidth: true
                    color: "transparent"

                    SwbLabel {
                        anchors.centerIn: parent
                        text: qsTr("Content")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                    }
                }
            }
        }
    }

    Section {
        title: qsTr("StackView")
        Rectangle {
            width: 300
            height: 130
            color: SwbTheme.background
            border.color: SwbTheme.border
            border.width: 1
            radius: SwbTheme.radius
            clip: true

            Component {
                id: stackDetailsPage

                Item {
                    Column {
                        anchors.centerIn: parent
                        spacing: 8

                        SwbLabel {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Details")
                        }
                        SwbButton {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Back")
                            variant: "outline"
                            onClicked: stackView.popCurrentItem()
                        }
                    }
                }
            }

            SwbStackView {
                id: stackView

                anchors.fill: parent
                initialItem: Item {
                    Column {
                        anchors.centerIn: parent
                        spacing: 8

                        SwbLabel {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Overview")
                        }
                        SwbButton {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Open details")
                            onClicked: stackView.pushItem(stackDetailsPage)
                        }
                    }
                }
            }
        }
    }

    Section {
        title: qsTr("SwipeView")
        Rectangle {
            width: 300
            height: 130
            color: SwbTheme.background
            border.color: SwbTheme.border
            border.width: 1
            radius: SwbTheme.radius

            SwbSwipeView {
                id: swipeView

                anchors.fill: parent
                anchors.bottomMargin: 24

                Item {
                    SwbLabel {
                        anchors.centerIn: parent
                        text: qsTr("Page 1")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                    }
                }

                Item {
                    SwbLabel {
                        anchors.centerIn: parent
                        text: qsTr("Page 2")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                    }
                }

                Item {
                    SwbLabel {
                        anchors.centerIn: parent
                        text: qsTr("Page 3")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                    }
                }
            }

            SwbPageIndicator {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                count: swipeView.count
                currentIndex: swipeView.currentIndex
                onCurrentIndexChanged: swipeView.currentIndex = currentIndex
            }
        }
    }

    Section {
        title: qsTr("TabBar")
        Rectangle {
            width: 300
            height: 130
            color: SwbTheme.background
            border.color: SwbTheme.border
            border.width: 1
            radius: SwbTheme.radius

            SwbTabBar {
                id: tabBar

                x: 8
                y: 8
                width: parent.width - 16
                currentIndex: tabPages.currentIndex

                SwbTabButton { text: qsTr("Account") }
                SwbTabButton { text: qsTr("Security") }
                SwbTabButton { text: qsTr("Disabled"); enabled: false }
            }

            SwbSwipeView {
                id: tabPages

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: tabBar.bottom
                anchors.bottom: parent.bottom
                anchors.margins: 8
                currentIndex: tabBar.currentIndex

                Item {
                    SwbLabel {
                        anchors.centerIn: parent
                        text: qsTr("Account settings")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                    }
                }

                Item {
                    SwbLabel {
                        anchors.centerIn: parent
                        text: qsTr("Security settings")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                    }
                }
            }
        }
    }
}
