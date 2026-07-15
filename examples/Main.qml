import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import SwbControls

ApplicationWindow {
    id: window

    required property var languageController
    required property url homeVideoSource

    width: 1024
    height: 700
    minimumWidth: 720
    minimumHeight: 520
    visible: true
    title: qsTr("SWB-QML-UI")

    // Current page: 0 home, 1 component gallery, 2 dashboard.
    property int currentPage: 0
    readonly property int sidebarIconSize: SwbTheme.iconSize + 2

    background: Rectangle {
        color: SwbTheme.background
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar with an avatar, page navigation, settings, help, and theme controls.
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 64
            color: SwbTheme.background

            // Divider between the sidebar and page content.
            Rectangle {
                anchors.right: parent.right
                width: 1
                height: parent.height
                color: SwbTheme.border
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 14
                anchors.bottomMargin: 14
                spacing: 10

                // Avatar that opens the author profile popup.
                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40

                    RoundImage {
                        anchors.fill: parent
                        source: "assets/avatar.svg"
                        scale: avatarHover.hovered ? 1.08 : 1.0
                        Behavior on scale { NumberAnimation { duration: SwbTheme.animationDuration } }
                    }

                    HoverHandler {
                        id: avatarHover
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        onTapped: profilePopup.visible ? profilePopup.close() : profilePopup.open()
                    }

                    SwbPopup {
                        id: profilePopup
                        x: parent.width + 16
                        y: 0
                        width: 264

                        contentItem: RowLayout {
                            spacing: 12

                            RoundImage {
                                Layout.preferredWidth: 44
                                Layout.preferredHeight: 44
                                source: "assets/avatar.svg"
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                SwbLabel {
                                    text: qsTr("SWB-QML-UI")
                                }
                                SwbLabel {
                                    text: "xxmzwf@gmail.com"
                                    color: SwbTheme.mutedForeground
                                    font.weight: Font.Normal
                                    font.pixelSize: SwbTheme.fontSizeSm
                                }
                            }
                        }
                    }
                }

                Item { Layout.preferredHeight: 6 }

                // Home.
                SwbToolButton {
                    id: homeBtn
                    Layout.alignment: Qt.AlignHCenter
                    icon.source: "assets/icons/home.svg"
                    icon.width: window.sidebarIconSize
                    icon.height: window.sidebarIconSize
                    icon.color: homeBtn.checked ? SwbTheme.accentForeground : SwbTheme.mutedForeground
                    checked: window.currentPage === 0
                    onClicked: window.currentPage = 0
                }

                // Component gallery.
                SwbToolButton {
                    id: galleryBtn
                    Layout.alignment: Qt.AlignHCenter
                    icon.source: "assets/icons/grid.svg"
                    icon.width: window.sidebarIconSize
                    icon.height: window.sidebarIconSize
                    icon.color: galleryBtn.checked ? SwbTheme.accentForeground : SwbTheme.mutedForeground
                    checked: window.currentPage === 1
                    onClicked: window.currentPage = 1
                }

                // Dashboard composed from controls in the library.
                SwbToolButton {
                    id: dashboardBtn
                    Layout.alignment: Qt.AlignHCenter
                    icon.source: "assets/icons/dashboard.svg"
                    icon.width: window.sidebarIconSize
                    icon.height: window.sidebarIconSize
                    icon.color: dashboardBtn.checked ? SwbTheme.accentForeground : SwbTheme.mutedForeground
                    checked: window.currentPage === 2
                    onClicked: window.currentPage = 2
                }

                Item { Layout.fillHeight: true }

                // Switch between the English source text and the Chinese translation.
                SwbToolButton {
                    id: languageButton
                    Layout.alignment: Qt.AlignHCenter
                    icon.source: "assets/icons/language.svg"
                    icon.width: window.sidebarIconSize
                    icon.height: window.sidebarIconSize
                    icon.color: languageButton.checked ? SwbTheme.accentForeground : SwbTheme.mutedForeground
                    checked: window.languageController.chinese
                    onClicked: window.languageController.toggleLanguage()
                }

                // Settings drawer.
                SwbToolButton {
                    Layout.alignment: Qt.AlignHCenter
                    icon.source: "assets/icons/gear.svg"
                    icon.width: window.sidebarIconSize
                    icon.height: window.sidebarIconSize
                    icon.color: SwbTheme.mutedForeground
                    onClicked: settingsDrawer.open()
                }

                // About dialog.
                SwbToolButton {
                    Layout.alignment: Qt.AlignHCenter
                    icon.source: "assets/icons/help.svg"
                    icon.width: window.sidebarIconSize
                    icon.height: window.sidebarIconSize
                    icon.color: SwbTheme.mutedForeground
                    onClicked: aboutDialog.open()
                }

                // Theme toggle: sun in light mode and moon in dark mode.
                SwbToolButton {
                    Layout.alignment: Qt.AlignHCenter
                    icon.source: SwbTheme.darkMode ? "assets/icons/moon.svg" : "assets/icons/sun.svg"
                    icon.width: window.sidebarIconSize
                    icon.height: window.sidebarIconSize
                    icon.color: SwbTheme.mutedForeground
                    onClicked: SwbTheme.darkMode = !SwbTheme.darkMode
                }
            }
        }

        // Vertically animated page container controlled by the sidebar.
        SwbSwipeView {
            id: pageView
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Vertical
            interactive: false
            clip: true
            currentIndex: window.currentPage

            HomePage {
                active: window.currentPage === 0
                videoSource: window.homeVideoSource
            }
            GalleryPage { active: window.currentPage === 1 }
            DashboardPage { active: window.currentPage === 2 }
        }
    }

    // Settings drawer that opens from the right.
    SwbDrawer {
        id: settingsDrawer
        edge: Qt.RightEdge

        contentItem: ColumnLayout {
            spacing: 12

            SwbLabel {
                text: qsTr("Settings")
                font.pixelSize: 16
            }

            SwbLabel {
                Layout.fillWidth: true
                text: qsTr("Appearance changes apply immediately.")
                color: SwbTheme.mutedForeground
                font.weight: Font.Normal
                wrapMode: Text.WordWrap
            }

            Item { Layout.preferredHeight: 8 }

            SwbSwitch {
                text: qsTr("Dark mode")
                checked: SwbTheme.darkMode
                onToggled: SwbTheme.darkMode = checked
            }

            Item { Layout.fillHeight: true }

            SwbButton {
                Layout.fillWidth: true
                text: qsTr("Close")
                variant: "outline"
                onClicked: settingsDrawer.close()
            }
        }
    }

    // About dialog.
    SwbDialog {
        id: aboutDialog
        parent: Overlay.overlay
        anchors.centerIn: parent
        width: Math.min(400, parent.width - 32)
        title: qsTr("About SWB-QML-UI")
        standardButtons: Dialog.Ok

        contentItem: ColumnLayout {
            spacing: 10

            SwbLabel {
                Layout.fillWidth: true
                text: qsTr("A modern control library built with Qt Quick Controls, currently featuring 51 visual components.")
                color: SwbTheme.mutedForeground
                font.weight: Font.Normal
                wrapMode: Text.WordWrap
            }

            SwbButton {
                variant: "link"
                leftPadding: 0
                text: qsTr("GitHub：github.com/xxmzwf/SWB-QML-UI")
                onClicked: Qt.openUrlExternally("https://github.com/xxmzwf/SWB-QML-UI")
            }

            SwbLabel {
                text: qsTr("Email: xxmzwf@gmail.com")
                font.weight: Font.Normal
            }
        }
    }
}
