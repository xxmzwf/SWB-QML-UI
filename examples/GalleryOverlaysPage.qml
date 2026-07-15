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
        title: qsTr("ToolBar")

        SwbToolBar {
            width: 300
            floating: true

            SwbToolButton { text: qsTr("New") }
            SwbToolButton { text: qsTr("Save") }
            SwbToolSeparator {}
            SwbToolButton {
                text: qsTr("Preview")
                checkable: true
                checked: true
            }
            SwbToolButton {
                text: qsTr("Disabled")
                enabled: false
            }
        }
    }

    Section {
        title: qsTr("MenuBar")

        SwbMenuBar {
            SwbMenu {
                title: qsTr("File")
                SwbMenuItem { text: qsTr("New File"); shortcutText: qsTr("⌘N") }
                SwbMenuItem { text: qsTr("Open File"); shortcutText: qsTr("⌘O") }
                SwbMenuSeparator {}
                SwbMenuItem { text: qsTr("Save"); enabled: false }
            }

            SwbMenu {
                title: qsTr("Edit")
                SwbMenuItem { text: qsTr("Undo"); shortcutText: qsTr("⌘Z") }
                SwbMenuItem { text: qsTr("Redo"); shortcutText: qsTr("⇧⌘Z") }
                SwbMenuSeparator {}
                SwbMenuItem { text: qsTr("Cut") }
                SwbMenuItem { text: qsTr("Copy") }
                SwbMenuItem { text: qsTr("Paste") }
            }

            SwbMenu {
                title: qsTr("View")
                SwbMenuItem { text: qsTr("Show Sidebar"); checkable: true; checked: true }
                SwbMenuSeparator {}
                SwbMenuItem { text: qsTr("Zoom In"); shortcutText: qsTr("⌘+") }
                SwbMenuItem { text: qsTr("Zoom Out"); shortcutText: qsTr("⌘−") }
            }

            SwbMenu {
                title: qsTr("Help")
                SwbMenuItem { text: qsTr("Documentation") }
                SwbMenuSeparator {}
                SwbMenuItem { text: qsTr("Reset Settings"); variant: "destructive" }
            }
        }
    }

    Section {
        title: qsTr("Popup")

        Item {
            Layout.preferredWidth: popupTrigger.implicitWidth
            Layout.preferredHeight: popupTrigger.implicitHeight

            SwbButton {
                id: popupTrigger

                text: qsTr("Open popup")
                onClicked: popup.visible ? popup.close() : popup.open()
            }

            SwbPopup {
                id: popup

                x: popupTrigger.x
                y: popupTrigger.y + popupTrigger.height + 4
                width: 288

                contentItem: Column {
                    spacing: 4

                    SwbLabel { text: qsTr("Dimensions") }
                    SwbLabel {
                        width: parent.width
                        text: qsTr("Set the width and height of the floating content.")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }

    Section {
        title: qsTr("Dialog")

        Row {
            spacing: 12

            SwbButton {
                text: qsTr("Edit profile")
                onClicked: profileDialog.open()
            }

            SwbLabel {
                id: dialogStatus

                anchors.verticalCenter: parent.verticalCenter
                color: SwbTheme.mutedForeground
                font.weight: Font.Normal
            }
        }

        SwbDialog {
            id: profileDialog

            parent: Overlay.overlay
            anchors.centerIn: parent
            width: Math.min(384, parent.width - 32)
            title: qsTr("Edit profile")
            standardButtons: Dialog.Save | Dialog.Cancel

            contentItem: ColumnLayout {
                spacing: 10

                SwbLabel {
                    Layout.fillWidth: true
                    text: qsTr("Update your account information.")
                    color: SwbTheme.mutedForeground
                    font.weight: Font.Normal
                    wrapMode: Text.WordWrap
                }
                SwbLabel {
                    Layout.fillWidth: true
                    text: qsTr("Name")
                }
                SwbTextField {
                    Layout.fillWidth: true
                    text: qsTr("Ada Lovelace")
                }
            }

            onAccepted: dialogStatus.text = qsTr("Saved")
            onRejected: dialogStatus.text = qsTr("Cancelled")
        }
    }

    Section {
        title: qsTr("Drawer")

        Row {
            spacing: 8

            SwbButton {
                text: qsTr("Left")
                variant: "secondary"
                onClicked: { demoDrawer.edge = Qt.LeftEdge; demoDrawer.open() }
            }
            SwbButton {
                text: qsTr("Right")
                variant: "secondary"
                onClicked: { demoDrawer.edge = Qt.RightEdge; demoDrawer.open() }
            }
            SwbButton {
                text: qsTr("Top")
                variant: "secondary"
                onClicked: { demoDrawer.edge = Qt.TopEdge; demoDrawer.open() }
            }
            SwbButton {
                text: qsTr("Bottom")
                variant: "secondary"
                onClicked: { demoDrawer.edge = Qt.BottomEdge; demoDrawer.open() }
            }
        }

        SwbDrawer {
            id: demoDrawer

            edge: Qt.BottomEdge
            handleVisible: true

            contentItem: Item {
                implicitWidth: drawerBody.implicitWidth
                implicitHeight: drawerBody.implicitHeight

                ColumnLayout {
                    id: drawerBody

                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.min(384, parent.width)
                    height: parent.height
                    spacing: 10

                    SwbLabel {
                        Layout.fillWidth: true
                        text: qsTr("Move Goal")
                        font.pixelSize: 16
                    }
                    SwbLabel {
                        Layout.fillWidth: true
                        text: qsTr("Set your daily activity goal.")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                        wrapMode: Text.WordWrap
                    }
                    Item { Layout.fillHeight: true }
                    SwbButton {
                        Layout.fillWidth: true
                        text: qsTr("Close")
                        onClicked: demoDrawer.close()
                    }
                }
            }
        }
    }

    Section {
        title: qsTr("ToolTip")

        Row {
            spacing: 12

            SwbButton {
                id: tipButton

                text: qsTr("Hover")
                variant: "outline"

                SwbToolTip {
                    visible: tipButton.hovered
                    text: qsTr("Add to library")
                }
            }

            SwbButton {
                id: delayTipButton

                text: qsTr("Delayed")
                variant: "outline"

                SwbToolTip {
                    visible: delayTipButton.hovered
                    delay: 600
                    text: qsTr("Appears after a short delay.")
                }
            }
        }
    }
}
