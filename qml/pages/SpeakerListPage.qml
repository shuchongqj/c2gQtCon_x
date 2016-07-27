// ekke (Ekkehard Gentz) @ekkescorner
import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import org.ekkescorner.data 1.0
import "../common"

Page {
    id: speakerListPage
    focus: true
    property string name: "SpeakerListPage"
    bottomPadding: 24
    topPadding: 16

    // SECTION HEADER
    Component {
        id: sectionHeading
        ColumnLayout {
            width: parent.width
            LabelTitle {
                topPadding: 6
                bottomPadding: 6
                leftPadding: 16
                text: section
                anchors.verticalCenter: parent.verticalCenter
                color: primaryColor
                font.bold: true
            }
            HorizontalListDivider{}
        } // col layout
    }

    // LIST ROW DELEGTE
    Component {
        id: speakerRowComponent
        ColumnLayout {
            id: dataColumn
            // without this divider not over total width
            implicitWidth: appWindow.width
            RowLayout {
                spacing: 20
                Layout.fillWidth: true
                Layout.leftMargin: 16+12
                Layout.rightMargin: 6
                Layout.topMargin: 6
                SpeakerImageItem {
                    speaker: model.modelData
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    width: dataColumn.implicitWidth
                    spacing: 0
                    LabelSubheading {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        rightPadding: 12
                        text: model.modelData.name.length? model.modelData.name : qsTr("Unnamed Speaker")
                        font.bold: true
                        wrapMode: Label.WordWrap
                    } // label
                    // TODO Bugreport wrapmode not working
                    LabelBody {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        rightPadding: 12
                        text: dataColumn.ListView.view.sessionInfo(model.modelData)
                        wrapMode: Label.WordWrap
                        maximumLineCount: 3
                        elide: Label.ElideRight
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        navPane.pushSpeakerDetail(model.modelData.speakerId)
                    }
                } // mouse
            } // end Row Layout
            HorizontalListDivider{}
        } // end Col Layout
    } // speakerRowComponent

    // LIST VIEW
    ListView {
        id: listView
        focus: true
        clip: true
        // highlight: Rectangle {color: Material.listHighlightColor }
        currentIndex: -1
        anchors.fill: parent
        // setting the margin to be able to scroll the list above the FAB to use the Switch on last row
        // bottomMargin: 40
        // QList<Speaker*>
        //model: dataManager.speakerPropertyList

        delegate: speakerRowComponent
        // header: headerComponent
        // in Landscape header scrolls away
        // in protrait header always visible
        // headerPositioning: isLandscape? ListView.PullBackHeader : ListView.OverlayHeader

        section.property: "sortGroup"
        section.criteria: ViewSection.FullString
        section.delegate: sectionHeading

        ScrollIndicator.vertical: ScrollIndicator { }

        function sessionInfo(speaker) {
            var s = ""
            for (var i = 0; i < speaker.sessionsAsQVariantList().length; i++) {
                if(i > 0) {
                    s += "\n"
                }
                s += speaker.sessionsAsQVariantList()[i].title
            }
            return s
        }
    } // end listView

    Component.onDestruction: {
        cleanup()
    }

    // called immediately after Loader.loaded
    function init() {
        console.log(qsTr("Init done from SpeakerListPage"))
        console.log("Speaker# "+dataManager.speakerPropertyList.length)
        listView.model = dataManager.speakerPropertyList
    }
    // called from Component.destruction
    function cleanup() {
        console.log(qsTr("Cleanup done from SpeakerListPage"))
    }
} // end primaryPage