pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Controls.impl
import SwbControls

Item {
    id: dashboard

    property bool active: true

    component DashboardCard: SwbFrame {
        id: card

        property string title: ""
        property string description: ""
        property bool stretchHeight: false
        default property alias items: cardBody.data

        Layout.fillWidth: true
        Layout.fillHeight: stretchHeight
        Layout.preferredWidth: 1
        Layout.alignment: Qt.AlignTop

        contentItem: ColumnLayout {
            spacing: 12

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3

                SwbLabel {
                    Layout.fillWidth: true
                    text: card.title
                    font.pixelSize: 16
                }

                SwbLabel {
                    Layout.fillWidth: true
                    visible: card.description.length > 0
                    text: card.description
                    color: SwbTheme.mutedForeground
                    font.weight: Font.Normal
                    wrapMode: Text.WordWrap
                }
            }

            ColumnLayout {
                id: cardBody
                Layout.fillWidth: true
                spacing: 10
            }
        }
    }

    component Divider: Rectangle {
        Layout.fillWidth: true
        implicitHeight: 1
        color: SwbTheme.border
    }

    component DetailRow: RowLayout {
        property string label: ""
        property string value: ""

        Layout.fillWidth: true

        SwbLabel {
            Layout.fillWidth: true
            text: parent.label
            color: SwbTheme.mutedForeground
            font.weight: Font.Normal
        }

        SwbLabel { text: parent.value }
    }

    component GoalPanel: Rectangle {
        id: goal

        property string category: ""
        property string amount: ""
        property string detail: ""
        property real progress: 0

        Layout.fillWidth: true
        implicitHeight: goalLayout.implicitHeight + 24
        radius: SwbTheme.radiusSm
        color: SwbTheme.withAlpha(SwbTheme.secondary, 0.5)

        ColumnLayout {
            id: goalLayout
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            SwbLabel {
                text: goal.category.toUpperCase()
                color: SwbTheme.mutedForeground
                font.pixelSize: 12
                font.weight: Font.Normal
            }

            SwbLabel {
                text: goal.amount
                font.pixelSize: 24
            }

            SwbProgressBar {
                Layout.fillWidth: true
                value: goal.progress
            }

            SwbLabel {
                Layout.fillWidth: true
                text: goal.detail
                color: SwbTheme.mutedForeground
                font.weight: Font.Normal
                font.pixelSize: SwbTheme.fontSizeSm
            }
        }
    }

    component ActivityRow: Rectangle {
        id: activity

        property string symbol: ""
        property string name: ""
        property string detail: ""
        property string amount: ""

        Layout.fillWidth: true
        implicitHeight: 56
        radius: SwbTheme.radiusSm
        color: SwbTheme.withAlpha(SwbTheme.secondary, 0.5)

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Rectangle {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                radius: SwbTheme.radiusSm
                color: SwbTheme.background
                border.color: SwbTheme.border
                border.width: 1

                SwbLabel {
                    anchors.centerIn: parent
                    text: activity.symbol
                    font.pixelSize: 12
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                SwbLabel {
                    Layout.fillWidth: true
                    text: activity.name
                    elide: Text.ElideRight
                }

                SwbLabel {
                    Layout.fillWidth: true
                    text: activity.detail
                    color: SwbTheme.mutedForeground
                    font.weight: Font.Normal
                    font.pixelSize: SwbTheme.fontSizeSm
                    elide: Text.ElideRight
                }
            }

            SwbLabel { text: activity.amount }
        }
    }

    component SettingRow: RowLayout {
        id: setting

        property string label: ""
        property string description: ""
        property alias checked: toggle.checked

        Layout.fillWidth: true
        spacing: 12

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            SwbLabel {
                Layout.fillWidth: true
                text: setting.label
            }

            SwbLabel {
                Layout.fillWidth: true
                text: setting.description
                color: SwbTheme.mutedForeground
                font.weight: Font.Normal
                font.pixelSize: SwbTheme.fontSizeSm
                wrapMode: Text.WordWrap
            }
        }

        SwbSwitch { id: toggle }
    }

    component LevelRow: RowLayout {
        id: level

        property string label: ""
        property real value: 0

        Layout.fillWidth: true
        spacing: 10

        SwbLabel {
            Layout.preferredWidth: 72
            text: level.label
        }

        SwbSlider {
            Layout.fillWidth: true
            value: level.value
        }
    }

    component NavigationItem: SwbToolButton {
        id: navigationItem

        property bool selected: false

        Layout.fillWidth: true
        size: "sm"
        display: AbstractButton.TextBesideIcon
        checked: selected
        icon.color: selected ? SwbTheme.accentForeground : SwbTheme.mutedForeground

        contentItem: IconLabel {
            spacing: navigationItem.spacing
            mirrored: navigationItem.mirrored
            display: navigationItem.display
            icon: navigationItem.icon
            text: navigationItem.text
            font: navigationItem.font
            color: navigationItem.textColor
            alignment: Qt.AlignLeft | Qt.AlignVCenter
        }
    }

    component NewChatCard: SwbFrame {
        Layout.fillWidth: true
        Layout.preferredWidth: 1
        Layout.minimumHeight: 392
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        contentItem: ColumnLayout {
            spacing: 12

            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3

                    SwbLabel {
                        text: qsTr("New Chat")
                        font.pixelSize: 16
                    }

                    SwbLabel {
                        text: qsTr("How can I help you today?")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                    }
                }

                SwbToolButton {
                    variant: "outline"
                    icon.source: "assets/icons/chat-refresh.svg"
                    icon.color: SwbTheme.foreground
                }
            }

            Divider {}

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 136

                ColumnLayout {
                    anchors.centerIn: parent
                    width: Math.min(parent.width, 300)
                    spacing: 8

                    SwbToolButton {
                        Layout.alignment: Qt.AlignHCenter
                        variant: "outline"
                        icon.source: "assets/icons/chat-bubble.svg"
                        icon.color: SwbTheme.foreground
                    }

                    SwbLabel {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Start a conversation")
                        font.pixelSize: 16
                    }

                    SwbLabel {
                        Layout.fillWidth: true
                        text: qsTr("Ask a question, outline an idea, or describe what you want to build.")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: composerLayout.implicitHeight + 16
                radius: SwbTheme.radius
                color: SwbTheme.withAlpha(SwbTheme.secondary, 0.5)

                ColumnLayout {
                    id: composerLayout
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    SwbTextArea {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 72
                        placeholderText: qsTr("Write a message...")
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        SwbToolButton {
                            variant: "outline"
                            size: "sm"
                            icon.source: "assets/icons/chat-plus.svg"
                            icon.color: SwbTheme.foreground
                        }

                        Item { Layout.fillWidth: true }

                        SwbToolButton {
                            size: "sm"
                            checked: true
                            icon.source: "assets/icons/chat-send.svg"
                            icon.color: SwbTheme.accentForeground
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: SwbTheme.background
    }

    SwbScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            width: scroll.availableWidth
            spacing: 16

            GalleryFeaturedCarousel {
                id: featuredCarousel

                readonly property Flickable viewport: scroll.contentItem as Flickable
                readonly property bool mostlyInViewport: {
                    if (!viewport || height <= 0)
                        return false

                    viewport.contentY
                    const top = featuredCarousel.mapToItem(scroll, 0, 0).y
                    const visibleHeight = Math.max(0, Math.min(scroll.height, top + height) - Math.max(0, top))
                    return visibleHeight >= height / 2
                }

                active: dashboard.active && visible && mostlyInViewport
                Layout.fillWidth: true
                Layout.topMargin: 24
                Layout.leftMargin: 24
                Layout.rightMargin: 24
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                spacing: 16

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3

                    SwbLabel {
                        text: qsTr("Dashboard")
                        font.pixelSize: 24
                    }

                    SwbLabel {
                        Layout.fillWidth: true
                        text: qsTr("A practical workspace composed from the control library.")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                        wrapMode: Text.WordWrap
                    }
                }

                SwbButton {
                    text: qsTr("New goal")
                    variant: "outline"
                }
            }

            GridLayout {
                id: dashboardGrid
                Layout.fillWidth: true
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                columns: width >= 840 ? 3 : width >= 560 ? 2 : 1
                columnSpacing: 16
                rowSpacing: 16

                DashboardCard {
                    stretchHeight: true
                    title: qsTr("Account Overview")
                    description: qsTr("Balances ready for your next payout.")

                    SwbLabel {
                        text: "$12,480.00"
                        font.pixelSize: 30
                    }

                    Row {
                        spacing: 6

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 8
                            height: 8
                            radius: 4
                            color: SwbTheme.foreground
                        }

                        SwbLabel {
                            text: qsTr("Ready to transfer")
                            color: SwbTheme.mutedForeground
                            font.weight: Font.Normal
                            font.pixelSize: SwbTheme.fontSizeSm
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: accountRows.implicitHeight + 24
                        radius: SwbTheme.radiusSm
                        color: SwbTheme.withAlpha(SwbTheme.secondary, 0.5)

                        ColumnLayout {
                            id: accountRows
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            DetailRow { label: qsTr("Monthly income"); value: "$4,230.00" }
                            DetailRow { label: qsTr("Pending"); value: "$680.00" }
                            Divider {}
                            DetailRow { label: qsTr("Next payout"); value: qsTr("Jul 28") }
                        }
                    }

                    SwbButton {
                        Layout.fillWidth: true
                        text: qsTr("View account")
                    }

                    SwbLabel {
                        Layout.fillWidth: true
                        text: qsTr("Eligible funds are transferred automatically on the next payout date.")
                        color: SwbTheme.mutedForeground
                        font.weight: Font.Normal
                        font.pixelSize: SwbTheme.fontSizeSm
                        wrapMode: Text.WordWrap
                    }
                }

                DashboardCard {
                    stretchHeight: true
                    title: qsTr("Payout Settings")
                    description: qsTr("Configure when available funds are released.")

                    SwbLabel { text: qsTr("Preferred currency") }

                    SwbComboBox {
                        Layout.fillWidth: true
                        model: [qsTr("USD — United States Dollar"), qsTr("EUR — Euro"), qsTr("GBP — British Pound")]
                    }

                    DetailRow { label: qsTr("Minimum payout"); value: "$2,500.00" }

                    SwbSlider {
                        Layout.fillWidth: true
                        value: 0.42
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        SwbLabel {
                            Layout.fillWidth: true
                            text: "$50 (MIN)"
                            color: SwbTheme.mutedForeground
                            font.weight: Font.Normal
                            font.pixelSize: SwbTheme.fontSizeSm
                        }
                        SwbLabel {
                            text: "$10,000 (MAX)"
                            color: SwbTheme.mutedForeground
                            font.weight: Font.Normal
                            font.pixelSize: SwbTheme.fontSizeSm
                        }
                    }

                    SwbTextArea {
                        Layout.fillWidth: true
                        placeholderText: qsTr("Add a note for this payout...")
                    }

                    SwbButton {
                        Layout.fillWidth: true
                        text: qsTr("Save settings")
                    }
                }

                DashboardCard {
                    stretchHeight: true
                    title: qsTr("Savings Goals")
                    description: qsTr("Active milestones for this year.")

                    GoalPanel {
                        category: qsTr("Emergency fund")
                        amount: "$24,000"
                        progress: 0.8
                        detail: qsTr("80% achieved · $4,800 remaining")
                    }

                    GoalPanel {
                        category: qsTr("New workspace")
                        amount: "$8,500"
                        progress: 0.35
                        detail: qsTr("35% achieved · $5,525 remaining")
                    }

                    SwbButton {
                        Layout.fillWidth: true
                        text: qsTr("Create another goal")
                        variant: "outline"
                    }
                }

                DashboardCard {
                    stretchHeight: true
                    title: qsTr("Recent Activity")
                    description: qsTr("Your latest account movements.")

                    SwbSearchField {
                        Layout.fillWidth: true
                        placeholderText: qsTr("Search activity")
                    }

                    ActivityRow { symbol: "CO"; name: qsTr("Coffee Office"); detail: qsTr("Food & Drink"); amount: "-$18.40" }
                    ActivityRow { symbol: "MK"; name: qsTr("Market Square"); detail: qsTr("Groceries"); amount: "-$86.25" }
                    ActivityRow { symbol: "PY"; name: qsTr("Client Payout"); detail: qsTr("Income"); amount: "+$2,450" }
                    ActivityRow { symbol: "TR"; name: qsTr("City Transit"); detail: qsTr("Transport"); amount: "-$24.00" }
                }

                DashboardCard {
                    stretchHeight: true
                    title: qsTr("Preferences")
                    description: qsTr("Manage notifications and payout behavior.")

                    SwbLabel { text: qsTr("Default currency") }

                    SwbComboBox {
                        Layout.fillWidth: true
                        model: [qsTr("USD — United States Dollar"), qsTr("EUR — Euro"), qsTr("GBP — British Pound")]
                    }

                    Divider {}
                    SettingRow { label: qsTr("Public statistics"); description: qsTr("Allow summary metrics to be shared."); checked: true }
                    SettingRow { label: qsTr("Automatic payouts"); description: qsTr("Transfer eligible funds each month."); checked: true }
                    SettingRow { label: qsTr("Weekly digest"); description: qsTr("Receive a compact activity summary.") }
                    Divider {}

                    RowLayout {
                        Layout.fillWidth: true
                        SwbButton { text: qsTr("Reset"); variant: "outline" }
                        Item { Layout.fillWidth: true }
                        SwbButton { text: qsTr("Save preferences") }
                    }
                }

                DashboardCard {
                    stretchHeight: true
                    title: qsTr("Workspace Controls")
                    description: qsTr("Tune a connected room profile.")

                    SettingRow { label: qsTr("Kitchen Island"); description: qsTr("Ambient profile is active."); checked: true }

                    Flow {
                        Layout.fillWidth: true
                        spacing: 6
                        SwbButton { text: qsTr("Cooking"); size: "sm"; variant: "secondary" }
                        SwbButton { text: qsTr("Dining"); size: "sm"; variant: "outline" }
                        SwbButton { text: qsTr("Focus"); size: "sm"; variant: "outline" }
                    }

                    Divider {}
                    LevelRow { label: qsTr("Brightness"); value: 0.78 }
                    LevelRow { label: qsTr("Color temp"); value: 0.62 }
                    LevelRow { label: qsTr("Volume"); value: 0.35 }
                    LevelRow { label: qsTr("Fade"); value: 0.12 }
                }

                DashboardCard {
                    stretchHeight: true
                    title: qsTr("Quick Transfer")
                    description: qsTr("Send available funds to a saved destination.")

                    SwbLabel { text: qsTr("Amount") }
                    SwbTextField { Layout.fillWidth: true; text: "$500.00" }
                    SwbLabel { text: qsTr("Destination") }
                    SwbComboBox {
                        Layout.fillWidth: true
                        model: [qsTr("Primary checking"), qsTr("Savings account"), qsTr("Business reserve")]
                    }
                    SwbCheckBox { text: qsTr("Schedule for next business day"); checked: true }
                    SwbButton { Layout.fillWidth: true; text: qsTr("Review transfer") }
                }

                DashboardCard {
                    stretchHeight: true
                    title: qsTr("Security & Alerts")
                    description: qsTr("Choose how account changes are confirmed.")

                    SwbCheckBox { text: qsTr("Require confirmation for payouts"); checked: true }
                    SwbCheckBox { text: qsTr("Alert on a new sign-in"); checked: true }
                    SwbCheckBox { text: qsTr("Monthly security summary") }
                    Divider {}
                    DetailRow { label: qsTr("Two-factor authentication"); value: qsTr("Enabled") }
                    DetailRow { label: qsTr("Active sessions"); value: "2" }
                    SwbButton { Layout.fillWidth: true; text: qsTr("Manage security"); variant: "outline" }
                }

                DashboardCard {
                    stretchHeight: true
                    title: qsTr("Help Center")
                    description: qsTr("Find an answer or contact support.")

                    SwbSearchField {
                        Layout.fillWidth: true
                        placeholderText: qsTr("Search help")
                    }

                    SwbButton { Layout.fillWidth: true; text: qsTr("Connecting an account"); variant: "outline" }
                    SwbButton { Layout.fillWidth: true; text: qsTr("Exporting account data"); variant: "outline" }
                    SwbButton { Layout.fillWidth: true; text: qsTr("Understanding payouts"); variant: "outline" }
                    Divider {}
                    SwbButton { Layout.fillWidth: true; text: qsTr("Contact support") }
                }
            }

            GridLayout {
                id: navigationShowcase

                readonly property real showcaseWidth: scroll.availableWidth - 48
                readonly property real navigationColumnWidth: columns === 3
                                                              ? Math.min(160, (width - 2 * columnSpacing) / 3)
                                                              : columns === 2
                                                                ? Math.min(160, (width - columnSpacing) / 2)
                                                                : Math.min(160, width)
                readonly property real chatColumnWidth: columns === 3
                                                        ? width - 2 * navigationColumnWidth - 2 * columnSpacing
                                                        : width

                Layout.fillWidth: false
                Layout.leftMargin: 24
                Layout.rightMargin: 24
                Layout.bottomMargin: 24
                Layout.minimumWidth: showcaseWidth
                Layout.preferredWidth: showcaseWidth
                Layout.maximumWidth: showcaseWidth
                columns: scroll.availableWidth >= 840 ? 3 : scroll.availableWidth >= 560 ? 2 : 1
                columnSpacing: 16
                rowSpacing: 16

                ColumnLayout {
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    Layout.minimumWidth: navigationShowcase.navigationColumnWidth
                    Layout.preferredWidth: navigationShowcase.navigationColumnWidth
                    Layout.maximumWidth: navigationShowcase.navigationColumnWidth
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    spacing: 16

                    DashboardCard {
                        stretchHeight: true
                        title: qsTr("Planning")

                        NavigationItem { text: qsTr("Documents"); icon.source: "assets/icons/nav-documents.svg" }
                        NavigationItem { text: qsTr("Budget"); icon.source: "assets/icons/nav-budget.svg" }
                        NavigationItem { text: qsTr("Reports"); icon.source: "assets/icons/nav-reports.svg" }
                        NavigationItem { text: qsTr("Goals"); icon.source: "assets/icons/nav-goals.svg" }
                    }

                    DashboardCard {
                        stretchHeight: true
                        title: qsTr("Overview")

                        NavigationItem { text: qsTr("Analytics"); icon.source: "assets/icons/nav-analytics.svg"; selected: true }
                        NavigationItem { text: qsTr("Transactions"); icon.source: "assets/icons/nav-transactions.svg" }
                        NavigationItem { text: qsTr("Investments"); icon.source: "assets/icons/nav-investments.svg" }
                        NavigationItem { text: qsTr("Spending"); icon.source: "assets/icons/nav-spending.svg" }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    Layout.minimumWidth: navigationShowcase.navigationColumnWidth
                    Layout.preferredWidth: navigationShowcase.navigationColumnWidth
                    Layout.maximumWidth: navigationShowcase.navigationColumnWidth
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    spacing: 16

                    DashboardCard {
                        stretchHeight: true
                        title: qsTr("Support")

                        NavigationItem { text: qsTr("Help Center"); icon.source: "assets/icons/nav-help-center.svg" }
                        NavigationItem { text: qsTr("Docs"); icon.source: "assets/icons/nav-documentation.svg" }
                        NavigationItem { text: qsTr("Contact Us"); icon.source: "assets/icons/nav-contact.svg" }
                        NavigationItem { text: qsTr("Status"); icon.source: "assets/icons/nav-status.svg" }
                    }

                    DashboardCard {
                        stretchHeight: true
                        title: qsTr("Account")

                        NavigationItem { text: qsTr("Profile"); icon.source: "assets/icons/nav-profile.svg" }
                        NavigationItem { text: qsTr("Billing"); icon.source: "assets/icons/nav-billing.svg"; selected: true }
                        NavigationItem { text: qsTr("Notifications"); icon.source: "assets/icons/nav-notifications.svg" }
                        NavigationItem { text: qsTr("Security"); icon.source: "assets/icons/nav-security.svg" }
                    }
                }

                NewChatCard {
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    Layout.minimumWidth: navigationShowcase.chatColumnWidth
                    Layout.preferredWidth: navigationShowcase.chatColumnWidth
                    Layout.maximumWidth: navigationShowcase.chatColumnWidth
                    Layout.columnSpan: navigationShowcase.columns < 3 ? navigationShowcase.columns : 1
                }
            }
        }
    }
}
