import QtQuick
import QtQuick.Controls
import "../Components"
import HIDCommander 1.0

Item {
    property string firmwareVersion: "no device found"
    id: page

    Column {
        id: contents
        height: parent.height
        width: parent.width * .9
        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            height: parent.height * .75
            width: parent.width
            Row {
                height: parent.height
                width: parent.width
                spacing: 10

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Connected Devices:"
                }

                ComboBox {
                    id: deviceList
                    height: 20
                    width: 300
                    model: HIDCommander.deviceList
                    anchors.verticalCenter: parent.verticalCenter
                }

                Button {
                    id: getFirmwareButton
                    height: 20
                    width: 100
                    enabled: deviceList.model !== undefined && deviceList.model.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Get Firmware"
                    onClicked: {
                        console.debug("Clicked, get firmware")
                        page.firmwareVersion = HIDCommander.getFirmwareFromIndex(deviceList.currentIndex);
                        popUp.visible = true;
                    }
                }
            }
        }



        Column {
            property int textWidth: 100

            id: colorPicker
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height * .2
            width: parent.width

            SliderInput {
                id: sliderR
                height: parent.height * .25
                width: parent.width
                value: 128
                label: "RED: "
            }

            SliderInput {
                id: sliderG
                height: parent.height * .25
                width: parent.width
                value: 128
                label: "GREEN: "
            }

            SliderInput {
                id: sliderB
                height: parent.height * .25
                width: parent.width
                value: 128
                label: "BLUE: "
            }

            Rectangle {
                id: colorBox
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height * .25
                width: parent.width
                color: Qt.rgba(sliderR.value / 255, sliderG.value / 255, sliderB.value / 255, 1)
                border.color: "black"
                border.width: 1
            }
        }
    }

    Popup {
        id: popUp
        visible: false
        height: parent.height * .8
        width: parent.width * .8
        anchors.centerIn: parent
        contentItem: Rectangle {
            anchors.fill: parent
            color: "lightBlue"
            Text {
                id: popUpText
                anchors.centerIn: parent
                text: page.firmwareVersion
            }
            Button {
                id: confirmButton
                height: 20
                width: 100
                anchors.top: popUpText.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                text: "OK"
                onClicked: {
                    console.debug("Clicked, popup confirm")
                    popUp.visible = false;
                }
            }
        }
    }
}
