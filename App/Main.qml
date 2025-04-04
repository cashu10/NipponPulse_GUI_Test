import QtQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("GUI Test")

    Rectangle {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        color: "lightGray"

        Row {
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            spacing: 5

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Application Up Time: "
            }

            Text {
                function formatSecondsToHHMMSS(seconds) {
                    const hours = Math.floor(seconds / 3600);
                    const minutes = Math.floor((seconds % 3600) / 60);
                    const secs = seconds % 60;

                    // Pad with leading zeros if necessary
                    const formattedHours = String(hours).padStart(2, '0');
                    const formattedMinutes = String(minutes).padStart(2, '0');
                    const formattedSeconds = String(secs).padStart(2, '0');

                    return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
                }

                anchors.verticalCenter: parent.verticalCenter
                text: formatSecondsToHHMMSS(upTimeTimer.upTime)
            }
        }

        Timer {
            property int upTime: 0
            id: upTimeTimer
            running: true
            repeat: true
            interval: 1000
            onTriggered: {
                upTime ++;
            }
        }
    }

    Loader {
        id: viewLoader_HID_Commander
        width: parent.width
        height: parent.height - footer.height
        anchors.top: parent.top
        anchors.left: parent.left
        source: "Views/HID_Commander.qml"
        onLoaded: {
            item.height = height;
            item.width = width;
        }

        active: true
    }
}
