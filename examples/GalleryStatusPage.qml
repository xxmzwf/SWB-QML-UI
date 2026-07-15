pragma ComponentBehavior: Bound
pragma Translator: "GalleryPage"
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import SwbControls

GalleryCategoryPage {
    id: page

    component Section: GallerySection { filterText: page.filterText }

    Section {
        id: progressBarSection

        title: qsTr("ProgressBar")

        readonly property Flickable viewport: page.contentItem as Flickable
        readonly property bool inViewport: {
            if (!viewport)
                return false
            viewport.contentY
            const top = progressBarSection.mapToItem(page, 0, 0).y
            return top < page.height && top + progressBarSection.height > 0
        }
        readonly property bool animationPaused: !page.active || !visible || !inViewport

        Flow {
            Layout.fillWidth: true
            spacing: 24
            SwbProgressBar { value: 0.25; width: 200 }
            SwbProgressBar { value: 0.6; width: 200 }
            SwbProgressBar {
                indeterminate: true
                animationPaused: progressBarSection.animationPaused
                width: 200
            }
        }
    }

    Section {
        id: busyIndicatorSection

        title: qsTr("BusyIndicator")

        readonly property Flickable viewport: page.contentItem as Flickable
        readonly property bool inViewport: {
            if (!viewport)
                return false
            viewport.contentY
            const top = busyIndicatorSection.mapToItem(page, 0, 0).y
            return top < page.height && top + busyIndicatorSection.height > 0
        }
        readonly property bool animationsRunning: page.active && visible && inViewport

        Flow {
            Layout.fillWidth: true
            spacing: 24
            SwbBusyIndicator {
                size: "sm"
                running: busyIndicatorSection.animationsRunning
            }
            SwbBusyIndicator {
                size: "default"
                running: busyIndicatorSection.animationsRunning
            }
            SwbBusyIndicator {
                size: "lg"
                running: busyIndicatorSection.animationsRunning
            }
            SwbBusyIndicator {
                size: "lg"
                color: SwbTheme.primary
                running: busyIndicatorSection.animationsRunning
            }
        }
    }

    Section {
        title: qsTr("PageIndicator")
        Flow {
            Layout.fillWidth: true
            spacing: 24
            SwbPageIndicator { count: 5; currentIndex: 0 }
            SwbPageIndicator { count: 5; currentIndex: 2 }
            SwbPageIndicator { count: 5; currentIndex: 4; enabled: false }
        }
    }

    Section {
        title: qsTr("ScrollView")
        Rectangle {
            width: 260
            height: 120
            color: "transparent"
            border.color: SwbTheme.border
            border.width: 1
            radius: SwbTheme.radius
            clip: true

            SwbScrollView {
                anchors.fill: parent

                ListView {
                    model: 12
                    clip: true

                    delegate: Item {
                        id: scrollViewItem

                        required property int index
                        width: ListView.view.width
                        height: 32

                        SwbLabel {
                            x: 16
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Item %1").arg(scrollViewItem.index + 1)
                        }
                    }
                }
            }
        }
    }

    Section {
        title: qsTr("ScrollIndicator")
        Rectangle {
            width: 260
            height: 120
            color: "transparent"
            border.color: SwbTheme.border
            border.width: 1
            radius: SwbTheme.radius
            clip: true

            ListView {
                id: indicatorList

                anchors.fill: parent
                anchors.margins: 8
                spacing: 6
                clip: true
                model: 12

                delegate: Rectangle {
                    id: indicatorItem

                    required property int index
                    width: ListView.view.width
                    height: 28
                    radius: 6
                    color: SwbTheme.secondary

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Item %1").arg(indicatorItem.index + 1)
                        color: SwbTheme.foreground
                        font.pixelSize: SwbTheme.fontSize
                    }
                }

                ScrollIndicator.vertical: SwbScrollIndicator {}
            }
        }
    }

    Section {
        title: qsTr("ScrollBar")
        Rectangle {
            width: 260
            height: 120
            color: "transparent"
            border.color: SwbTheme.border
            border.width: 1
            radius: SwbTheme.radius
            clip: true

            Flickable {
                id: demoFlick

                anchors.fill: parent
                anchors.margins: 8
                contentWidth: grid.width
                contentHeight: grid.height

                Grid {
                    id: grid

                    columns: 8
                    rowSpacing: 6
                    columnSpacing: 6

                    Repeater {
                        model: 40
                        delegate: Rectangle {
                            id: cell

                            required property int index
                            width: 60
                            height: 28
                            radius: 6
                            color: SwbTheme.secondary

                            Text {
                                anchors.centerIn: parent
                                text: cell.index + 1
                                color: SwbTheme.foreground
                                font.pixelSize: SwbTheme.fontSize
                            }
                        }
                    }
                }

                ScrollBar.vertical: SwbScrollBar {}
                ScrollBar.horizontal: SwbScrollBar {}
            }
        }
    }
}
