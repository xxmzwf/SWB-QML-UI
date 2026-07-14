pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQml.Models
import Qt.labs.qmlmodels
import SwbControls

// Component gallery with search, featured content, and categorized control cards.
Item {
    id: gallery

    // Pause timers and looping animations while this page is inactive.
    property bool active: true

    // Filter control cards by title.
    property string filterText: ""

    ListModel {
        id: featuredModel

        ListElement { imageSource: "assets/huawei.jpg"; tagText: QT_TR_NOOP("Limited Offer"); titleText: QT_TR_NOOP("HiSilicon Kirin Processors") }
        ListElement { imageSource: "assets/nvidia.jpg"; tagText: QT_TR_NOOP("Featured"); titleText: QT_TR_NOOP("NVIDIA Graphics Cards") }
        ListElement { imageSource: "assets/openai.jpg"; tagText: QT_TR_NOOP("Trending"); titleText: QT_TR_NOOP("OpenAI Technologies") }
        ListElement { imageSource: "assets/wechat.jpg"; tagText: QT_TR_NOOP("Recommended"); titleText: QT_TR_NOOP("WeChat Platform") }
        ListElement { imageSource: "assets/grok.jpg"; tagText: QT_TR_NOOP("New"); titleText: QT_TR_NOOP("Grok Assistant") }
    }

    // Reusable section card with a title and compact content container.
    component Section: Rectangle {
        id: sec
        property string title: ""
        property int bodyHeight: 0
        default property alias content: body.data

        // Hide non-matching cards and let the grid close any gaps.
        visible: gallery.filterText === ""
                 || title.toLowerCase().indexOf(gallery.filterText.toLowerCase()) !== -1

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        Layout.preferredHeight: bodyHeight > 0 ? bodyHeight : Math.max(96, body.implicitHeight + 24)
        color: SwbTheme.popover
        radius: SwbTheme.radius
        border.color: SwbTheme.border
        border.width: 1

        // Pin the title to the top-left and size the card from its content.
        ColumnLayout {
            id: body
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 12
            spacing: 8

            Text {
                text: sec.title
                color: SwbTheme.foreground
                font.pixelSize: 16
                font.weight: Font.DemiBold
                Layout.fillWidth: true
            }
        }
    }

    component CategoryHeader: RowLayout {
        id: categoryHeader

        property string title: ""

        visible: gallery.filterText === ""
        Layout.fillWidth: true
        Layout.preferredHeight: 32
        spacing: 12

        SwbLabel {
            text: categoryHeader.title
            font.pixelSize: 18
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: SwbTheme.border
        }
    }

    SwbScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            width: scroll.availableWidth
            spacing: 16

            // Page title and component search.
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

            // Compact featured rail with autoplay and horizontal snap navigation.
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.preferredHeight: Math.min(340, Math.max(260, width * 0.34))
                visible: gallery.filterText === ""
                color: SwbTheme.popover
                radius: SwbTheme.radius
                border.color: SwbTheme.border
                border.width: 1
                clip: true

                ListView {
                    id: carousel
                    readonly property real cardWidth: Math.max(0,
                                                               Math.min(width, Math.max(320, width * 0.72)))
                    readonly property real cardStep: cardWidth + spacing

                    function targetContentX(index) {
                        const centeredOffset = index * cardStep - (width - cardWidth) / 2
                        return Math.max(0, Math.min(centeredOffset,
                                                    Math.max(0, contentWidth - width)))
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
                        const centeredIndex = Math.round((contentX + (width - cardWidth) / 2)
                                                         / cardStep)
                        moveToIndex(centeredIndex, true)
                    }

                    NumberAnimation {
                        id: carouselMove
                        target: carousel
                        property: "contentX"
                        duration: SwbTheme.animationDuration
                        easing.type: Easing.OutCubic
                    }

                    delegate: Item {
                        id: slide

                        required property string imageSource
                        required property string tagText
                        required property string titleText

                        width: carousel.cardWidth
                        height: carousel.height

                        RoundImage {
                            anchors.fill: parent
                            radius: SwbTheme.radiusSm
                            source: slide.imageSource
                        }

                        // Bottom gradient that keeps the title readable.
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

                        // Top-left status badge.
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

                        // Bottom-left title and action.
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

                // Advance to the next slide while the page is active.
                Timer {
                    interval: 4000
                    running: gallery.active && gallery.filterText === ""
                    repeat: true
                    onTriggered: carousel.moveToIndex((carousel.currentIndex + 1) % carousel.count, true)
                }
            }

            GridLayout {
                id: cardGrid
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.bottomMargin: 24
                columnSpacing: 16
                rowSpacing: 16
                columns: width >= 720 ? 2 : 1

                CategoryHeader {
                    Layout.columnSpan: cardGrid.columns
                    title: qsTr("Common Controls")
                }

                Section {
                    title: qsTr("Button")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 12
                        SwbButton { text: qsTr("Default") }
                        SwbButton { text: qsTr("Secondary"); variant: "secondary" }
                        SwbButton { text: qsTr("Destructive"); variant: "destructive" }
                        SwbButton { text: qsTr("Outline"); variant: "outline" }
                        SwbButton { text: qsTr("Ghost"); variant: "ghost" }
                        SwbButton { text: qsTr("Link"); variant: "link" }
                        SwbButton { text: qsTr("Small"); size: "sm" }
                        SwbButton { text: qsTr("Large"); size: "lg" }
                    }
                }

                Section {
                    title: qsTr("ToolButton")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 12
                        SwbToolButton { text: qsTr("B"); checkable: true; checked: true; font.bold: true }
                        SwbToolButton { text: qsTr("I"); checkable: true; font.italic: true }
                        SwbToolButton { text: qsTr("U"); checkable: true; font.underline: true }
                        SwbToolButton { text: qsTr("★"); checkable: true }
                        SwbToolButton { text: qsTr("Outline"); variant: "outline" }
                        SwbToolButton { text: qsTr("Small"); variant: "outline"; size: "sm" }
                        SwbToolButton { text: qsTr("Large"); variant: "outline"; size: "lg" }
                        SwbToolButton { text: qsTr("⋯") }
                        SwbToolButton { text: qsTr("×"); enabled: false }
                        SwbToolButton { text: qsTr("x"); variant: "outline"; enabled: false }
                    }
                }

                Section {
                    title: qsTr("RoundButton")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 12
                        SwbRoundButton { text: qsTr("Default") }
                        SwbRoundButton { text: qsTr("Secondary"); variant: "secondary" }
                        SwbRoundButton { text: qsTr("Destructive"); variant: "destructive" }
                        SwbRoundButton { text: qsTr("Outline"); variant: "outline" }
                        SwbRoundButton { text: qsTr("Ghost"); variant: "ghost" }
                        SwbRoundButton { text: qsTr("＋") }
                        SwbRoundButton { text: qsTr("−"); variant: "secondary" }
                        SwbRoundButton { text: qsTr("★"); variant: "outline" }
                        SwbRoundButton { text: qsTr("S"); size: "sm" }
                        SwbRoundButton { text: qsTr("L"); size: "lg" }
                        SwbRoundButton { text: qsTr("×"); enabled: false }
                    }
                }

                Section {
                    title: qsTr("DelayButton")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 12
                        SwbDelayButton { text: qsTr("Hold to confirm"); onActivated: delayStatus.text = qsTr("Confirmed ✓") }
                        SwbDelayButton { text: qsTr("Hold to delete"); variant: "destructive"; onActivated: delayStatus.text = qsTr("Deleted") }
                        SwbDelayButton { text: qsTr("Small"); size: "sm" }
                        SwbDelayButton { text: qsTr("Large"); size: "lg" }
                        SwbDelayButton { text: qsTr("Disabled"); enabled: false }
                        Text {
                            id: delayStatus
                            text: qsTr("Press and hold a button")
                            color: SwbTheme.mutedForeground
                            font.pixelSize: SwbTheme.fontSize
                            height: SwbTheme.controlHeight
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Section {
                    title: qsTr("Switch")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 16
                        SwbSwitch { text: qsTr("Off by default") }
                        SwbSwitch { text: qsTr("On by default"); checked: true }
                        SwbSwitch { text: qsTr("Small"); size: "sm" }
                        SwbSwitch { text: qsTr("Disabled"); enabled: false }
                    }
                }

                Section {
                    title: qsTr("CheckBox")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 16
                        SwbCheckBox { text: qsTr("Accept terms"); checked: true }
                        SwbCheckBox { text: qsTr("Subscribe") }
                        SwbCheckBox { text: qsTr("Disabled"); enabled: false }
                        SwbCheckBox { text: qsTr("Disabled checked"); enabled: false; checked: true }
                    }
                }

                Section {
                    title: qsTr("RadioButton")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 16
                        SwbRadioButton { text: qsTr("Default"); checked: true }
                        SwbRadioButton { text: qsTr("Comfortable") }
                        SwbRadioButton { text: qsTr("Compact") }
                        SwbRadioButton { text: qsTr("Disabled"); enabled: false }
                    }
                }

                Section {
                    title: qsTr("Label")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 24
                        Column {
                            spacing: 6
                            SwbLabel { text: qsTr("Username") }
                            SwbTextField { placeholderText: qsTr("Username"); width: 200 }
                        }
                        Column {
                            spacing: 6
                            SwbLabel { text: qsTr("Disabled"); enabled: false }
                            SwbTextField { placeholderText: qsTr("Disabled"); enabled: false; width: 200 }
                        }
                    }
                }

                CategoryHeader {
                    Layout.columnSpan: cardGrid.columns
                    title: qsTr("Layout & Views")
                }

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

                CategoryHeader {
                    Layout.columnSpan: cardGrid.columns
                    title: qsTr("Menus & Overlays")
                }

                Section {
                    title: qsTr("ToolBar")

                    SwbToolBar {
                        width: 300
                        floating: true

                        SwbToolButton {
                            text: qsTr("New")
                        }

                        SwbToolButton {
                            text: qsTr("Save")
                        }

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

                                SwbLabel {
                                    text: qsTr("Dimensions")
                                }

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

                        // Keep drawer content centered and comfortably constrained.
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

                CategoryHeader {
                    Layout.columnSpan: cardGrid.columns
                    title: qsTr("Data & Containers")
                }

                Section {
                    title: qsTr("HeaderView & SelectionRectangle")
                    bodyHeight: 300

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 224

                        SwbHorizontalHeaderView {
                            id: demoHHeader
                            anchors.left: demoTable.left
                            anchors.top: parent.top
                            syncView: demoTable
                            clip: true
                            model: [qsTr("Invoice"), qsTr("Status"), qsTr("Amount")]
                        }

                        SwbVerticalHeaderView {
                            id: demoVHeader
                            anchors.left: parent.left
                            anchors.top: demoTable.top
                            syncView: demoTable
                            clip: true
                        }

                        TableView {
                            id: demoTable
                            anchors.left: demoVHeader.right
                            anchors.top: demoHHeader.bottom
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            clip: true
                            interactive: false

                            selectionModel: ItemSelectionModel {
                                model: demoTable.model
                            }

                            model: TableModel {
                                TableModelColumn { display: "invoice" }
                                TableModelColumn { display: "status" }
                                TableModelColumn { display: "amount" }

                                rows: [
                                    { invoice: "INV001", status: qsTr("Paid"), amount: "$250.00" },
                                    { invoice: "INV002", status: qsTr("Pending"), amount: "$150.00" },
                                    { invoice: "INV003", status: qsTr("Unpaid"), amount: "$350.00" },
                                    { invoice: "INV004", status: qsTr("Paid"), amount: "$450.00" }
                                ]
                            }

                            delegate: Rectangle {
                                required property string display
                                required property bool selected

                                implicitWidth: 104
                                implicitHeight: 36
                                color: selected ? SwbTheme.secondary : SwbTheme.background

                                // Row divider.
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    width: parent.width
                                    height: 1
                                    color: SwbTheme.border
                                }

                                Text {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    text: parent.display
                                    font.pixelSize: 12
                                    color: SwbTheme.foreground
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        SwbSelectionRectangle {
                            target: demoTable
                            selectionMode: SelectionRectangle.Drag
                        }
                    }

                    SwbLabel {
                        text: qsTr("Drag across cells to select.")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                    }
                }

                // Place the calendar beside table demos to keep regular cards compact.
                Section {
                    title: qsTr("Calendar")
                    Layout.fillHeight: false
                    Layout.alignment: Qt.AlignTop

                    Column {
                        id: cal
                        property int calYear: 2026
                        property int calMonth: 6      // Zero-based month: July.
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 6

                        // Month navigation aligned with the calendar body.
                        Item {
                            width: gridRow.width
                            height: 32
                            SwbToolButton {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                text: "‹"
                                size: "sm"
                                onClicked: {
                                    if (cal.calMonth === 0) { cal.calMonth = 11; cal.calYear-- }
                                    else cal.calMonth--
                                }
                            }
                            Text {
                                anchors.centerIn: parent
                                text: Qt.formatDate(new Date(cal.calYear, cal.calMonth, 1), "MMMM yyyy")
                                color: SwbTheme.foreground
                                font.pixelSize: SwbTheme.fontSize
                                font.weight: Font.DemiBold
                            }
                            SwbToolButton {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                text: "›"
                                size: "sm"
                                onClicked: {
                                    if (cal.calMonth === 11) { cal.calMonth = 0; cal.calYear++ }
                                    else cal.calMonth++
                                }
                            }
                        }

                        // Day header aligned with the week-number column.
                        Row {
                            spacing: SwbTheme.calendarSpacing
                            Item { width: SwbTheme.calendarCellSize; height: 1 }
                            SwbDayOfWeekRow {}
                        }

                        // Week numbers and month grid.
                        Row {
                            id: gridRow
                            spacing: SwbTheme.calendarSpacing
                            SwbWeekNumberColumn { month: cal.calMonth; year: cal.calYear }
                            SwbMonthGrid { month: cal.calMonth; year: cal.calYear }
                        }
                    }
                }

                Section {
                    title: qsTr("Frame")
                    SwbFrame {
                        width: 280

                        Column {
                            width: parent.width
                            spacing: 6

                            SwbLabel {
                                text: qsTr("Account settings")
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                            }
                            SwbLabel {
                                width: parent.width
                                text: qsTr("Manage your profile and preferences.")
                                color: SwbTheme.mutedForeground
                                font.weight: Font.Normal
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }

                Section {
                    title: qsTr("GroupBox")
                    SwbGroupBox {
                        width: 300
                        title: qsTr("Notification preferences")

                        Column {
                            width: parent.width
                            spacing: 12
                            SwbCheckBox { text: qsTr("Email notifications"); checked: true }
                            SwbCheckBox { text: qsTr("Product updates") }
                        }
                    }
                }

                CategoryHeader {
                    Layout.columnSpan: cardGrid.columns
                    title: qsTr("Input Controls")
                }

                Section {
                    title: qsTr("TextField")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 12
                        SwbTextField { placeholderText: qsTr("Email"); width: 220 }
                        SwbTextField { text: qsTr("Prefilled value"); width: 220 }
                        SwbTextField { placeholderText: qsTr("Disabled"); enabled: false; width: 220 }
                    }
                }

                Section {
                    title: qsTr("SearchField")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 12
                        SwbSearchField { width: 220 }
                        SwbSearchField { text: qsTr("Prefilled query"); width: 220 }
                        SwbSearchField { placeholderText: qsTr("Disabled"); enabled: false; width: 220 }
                    }
                }

                Section {
                    title: qsTr("TextArea")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 12
                        SwbTextArea { placeholderText: qsTr("Type your message here."); width: 170 }
                        SwbTextArea { text: qsTr("Prefilled multi-line\ncontent example."); width: 170 }
                        SwbTextArea { placeholderText: qsTr("Disabled"); enabled: false; width: 170 }
                    }
                }

                Section {
                    title: qsTr("ComboBox")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 12
                        SwbComboBox {
                            placeholderText: qsTr("Select a fruit")
                            currentIndex: -1
                            model: [qsTr("Apple"), qsTr("Banana"), qsTr("Orange"), qsTr("Grape"), qsTr("Watermelon")]
                            width: 220
                        }
                        SwbComboBox {
                            model: [qsTr("Light"), qsTr("Dark"), qsTr("System")]
                            width: 220
                        }
                        SwbComboBox {
                            model: [qsTr("Disabled")]
                            enabled: false
                            width: 220
                        }
                    }
                }

                Section {
                    title: qsTr("Slider")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 24
                        SwbSlider { value: 0.5; width: 200 }
                        SwbSlider { value: 0.3; stepSize: 0.1; width: 200 }
                        SwbSlider { value: 0.6; enabled: false; width: 200 }
                    }
                }

                Section {
                    title: qsTr("RangeSlider")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 24
                        SwbRangeSlider { first.value: 0.2; second.value: 0.8; width: 200 }
                        SwbRangeSlider { first.value: 0.3; second.value: 0.6; stepSize: 0.1; width: 200 }
                        SwbRangeSlider { first.value: 0.25; second.value: 0.75; enabled: false; width: 200 }
                    }
                }

                Section {
                    title: qsTr("Dial")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 16
                        SwbDial { value: 0.3 }
                        SwbDial { value: 0.6; stepSize: 0.1 }
                        SwbDial { value: 0.8; enabled: false }
                    }
                }

                Section {
                    title: qsTr("SpinBox")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 12
                        SwbSpinBox { from: 0; to: 100; value: 25; width: 140 }
                        SwbSpinBox { from: 0; to: 10; value: 5; width: 140 }
                        SwbSpinBox { from: 0; to: 10; value: 3; enabled: false; width: 140 }
                    }
                }

                Section {
                    title: qsTr("DoubleSpinBox")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 12
                        SwbDoubleSpinBox { from: 0; to: 10; value: 2.5; stepSize: 0.1; width: 140 }
                        SwbDoubleSpinBox { from: 0; to: 1; value: 0.5; stepSize: 0.05; width: 140 }
                        SwbDoubleSpinBox { from: 0; to: 100; value: 12.34; stepSize: 0.5; enabled: false; width: 140 }
                    }
                }

                Section {
                    title: qsTr("Tumbler")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 16
                        SwbTumbler { model: 24; height: 128 }
                        SwbTumbler { model: 60; height: 128 }
                        SwbTumbler {
                            model: [qsTr("Sun"), qsTr("Mon"), qsTr("Tue"), qsTr("Wed"), qsTr("Thu"), qsTr("Fri"), qsTr("Sat")]
                            height: 128
                        }
                        SwbTumbler { model: 12; enabled: false; height: 128 }
                    }
                }

                CategoryHeader {
                    Layout.columnSpan: cardGrid.columns
                    title: qsTr("Status & Scrolling")
                }

                Section {
                    title: qsTr("ProgressBar")
                    Flow {
                        Layout.fillWidth: true
                        spacing: 24
                        SwbProgressBar { value: 0.25; width: 200 }
                        SwbProgressBar { value: 0.6; width: 200 }
                        SwbProgressBar { value: 1.0; width: 200 }
                    }
                }

                Section {
                    id: busyIndicatorSection
                    title: qsTr("BusyIndicator")

                    // Animate only while this section intersects the viewport.
                    readonly property Flickable viewport: scroll.contentItem as Flickable
                    readonly property bool inViewport: {
                        if (!viewport)
                            return false
                        viewport.contentY
                        const top = busyIndicatorSection.mapToItem(scroll, 0, 0).y
                        return top < scroll.height && top + busyIndicatorSection.height > 0
                    }
                    readonly property bool animationsRunning: gallery.active && visible && inViewport

                    Flow {
                        Layout.fillWidth: true
                        spacing: 24
                        SwbBusyIndicator { size: "sm"; running: busyIndicatorSection.animationsRunning }
                        SwbBusyIndicator { size: "default"; running: busyIndicatorSection.animationsRunning }
                        SwbBusyIndicator { size: "lg"; running: busyIndicatorSection.animationsRunning }
                        SwbBusyIndicator { size: "lg"; color: SwbTheme.primary; running: busyIndicatorSection.animationsRunning }
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
                    // Two-axis scrolling demo with vertical and horizontal scroll bars.
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
        }
    }
}
