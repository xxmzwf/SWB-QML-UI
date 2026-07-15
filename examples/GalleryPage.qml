pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import SwbControls

// Component gallery that lazily loads one categorized page at a time.
Item {
    id: gallery

    property bool active: true
    property string filterText: ""
    property var visitedCategories: [false, false, false, false, false, false]

    function ensureCategoryLoaded(index) {
        if (index < 0 || index >= visitedCategories.length || visitedCategories[index])
            return

        const updatedCategories = visitedCategories.slice()
        updatedCategories[index] = true
        visitedCategories = updatedCategories
    }

    onActiveChanged: {
        if (active)
            ensureCategoryLoaded(categoryTabs.currentIndex)
    }
    Component.onCompleted: {
        if (active)
            ensureCategoryLoaded(categoryTabs.currentIndex)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 24
            Layout.leftMargin: 24
            Layout.rightMargin: 24

            Text {
                text: qsTr("Component Gallery")
                color: SwbTheme.foreground
                font.pixelSize: 24
                font.weight: Font.DemiBold
                Layout.fillWidth: true
            }

            SwbSearchField {
                placeholderText: qsTr("Search components")
                Layout.preferredWidth: 240
                onTextChanged: gallery.filterText = text
            }
        }

        SwbTabBar {
            id: categoryTabs

            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            variant: "line"
            onCurrentIndexChanged: {
                if (gallery.active)
                    gallery.ensureCategoryLoaded(currentIndex)
            }

            SwbTabButton { text: qsTr("Common Controls") }
            SwbTabButton { text: qsTr("Layout & Views") }
            SwbTabButton { text: qsTr("Menus & Overlays") }
            SwbTabButton { text: qsTr("Data & Containers") }
            SwbTabButton { text: qsTr("Input Controls") }
            SwbTabButton { text: qsTr("Status & Scrolling") }
        }

        Item {
            id: pageContainer

            readonly property var currentLoader: [
                commonPageLoader,
                layoutPageLoader,
                overlaysPageLoader,
                dataPageLoader,
                inputPageLoader,
                statusPageLoader
            ][categoryTabs.currentIndex]

            Layout.fillWidth: true
            Layout.fillHeight: true

            StackLayout {
                id: categoryPages

                anchors.fill: parent
                currentIndex: categoryTabs.currentIndex

                Loader {
                    id: commonPageLoader

                    asynchronous: true
                    active: gallery.visitedCategories[0]
                    sourceComponent: commonPage
                }

                Loader {
                    id: layoutPageLoader

                    asynchronous: true
                    active: gallery.visitedCategories[1]
                    sourceComponent: layoutPage
                }

                Loader {
                    id: overlaysPageLoader

                    asynchronous: true
                    active: gallery.visitedCategories[2]
                    sourceComponent: overlaysPage
                }

                Loader {
                    id: dataPageLoader

                    asynchronous: true
                    active: gallery.visitedCategories[3]
                    sourceComponent: dataPage
                }

                Loader {
                    id: inputPageLoader

                    asynchronous: true
                    active: gallery.visitedCategories[4]
                    sourceComponent: inputPage
                }

                Loader {
                    id: statusPageLoader

                    asynchronous: true
                    active: gallery.visitedCategories[5]
                    sourceComponent: statusPage
                }
            }

            SwbBusyIndicator {
                anchors.centerIn: parent
                running: !!pageContainer.currentLoader
                         && pageContainer.currentLoader.status === Loader.Loading
                visible: running
            }
        }
    }

    Component {
        id: commonPage

        GalleryCommonPage {
            active: gallery.active && categoryTabs.currentIndex === 0
            filterText: gallery.filterText
        }
    }

    Component {
        id: layoutPage

        GalleryLayoutPage {
            active: gallery.active && categoryTabs.currentIndex === 1
            filterText: gallery.filterText
        }
    }

    Component {
        id: overlaysPage

        GalleryOverlaysPage {
            active: gallery.active && categoryTabs.currentIndex === 2
            filterText: gallery.filterText
        }
    }

    Component {
        id: dataPage

        GalleryDataPage {
            active: gallery.active && categoryTabs.currentIndex === 3
            filterText: gallery.filterText
        }
    }

    Component {
        id: inputPage

        GalleryInputPage {
            active: gallery.active && categoryTabs.currentIndex === 4
            filterText: gallery.filterText
        }
    }

    Component {
        id: statusPage

        GalleryStatusPage {
            active: gallery.active && categoryTabs.currentIndex === 5
            filterText: gallery.filterText
        }
    }
}
