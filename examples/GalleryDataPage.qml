pragma ComponentBehavior: Bound
pragma Translator: "GalleryPage"
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQml.Models
import Qt.labs.qmlmodels
import SwbControls

GalleryCategoryPage {
    id: page

    component Section: GallerySection { filterText: page.filterText }

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

    Section {
        title: qsTr("Calendar")
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignTop

        Column {
            id: calendar

            property int calendarYear: 2026
            property int calendarMonth: 6

            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            Item {
                width: gridRow.width
                height: 32

                SwbToolButton {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "‹"
                    size: "sm"
                    onClicked: {
                        if (calendar.calendarMonth === 0) {
                            calendar.calendarMonth = 11
                            calendar.calendarYear--
                        } else {
                            calendar.calendarMonth--
                        }
                    }
                }
                Text {
                    anchors.centerIn: parent
                    text: Qt.formatDate(new Date(calendar.calendarYear, calendar.calendarMonth, 1), "MMMM yyyy")
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
                        if (calendar.calendarMonth === 11) {
                            calendar.calendarMonth = 0
                            calendar.calendarYear++
                        } else {
                            calendar.calendarMonth++
                        }
                    }
                }
            }

            Item {
                width: gridRow.width
                height: weekdayRow.implicitHeight

                SwbDayOfWeekRow {
                    id: weekdayRow

                    anchors.right: parent.right
                    width: monthGrid.width
                }
            }

            Row {
                id: gridRow

                spacing: SwbTheme.calendarSpacing
                SwbWeekNumberColumn { month: calendar.calendarMonth; year: calendar.calendarYear }
                SwbMonthGrid {
                    id: monthGrid

                    month: calendar.calendarMonth
                    year: calendar.calendarYear
                }
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
}
