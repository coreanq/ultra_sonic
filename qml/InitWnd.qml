import QtQuick 2.7
import QtQuick.Controls 2.0 
import QtQuick.Layouts 1.3
import "firmata"

Rectangle{
    signal dataReceived(int rawValue)
    signal portOpened()
    signal portClosed()
    id: initWnd
    color: "lightblue"
    clip: true


    PortSelector {
        id: port
        anchors.top: parent.top
        height:40
        width: parent.width
        Rectangle {
            id: back
            visible: false
            anchors.fill: parent
            color: "black"
            opacity: 0.5
        }

        Component.onCompleted: {

        }
        onDataReceived: {
            dataReceived(rawValue)
        }
        onPortOpened:  {
           back.visible= true
            portOpened()
        }
        onPortClosed:  {
            portClosed()
            back.visible = false
        }

    }

   Column{
            anchors.verticalCenter: initWnd.verticalCenter
            anchors.horizontalCenter: initWnd.horizontalCenter
        Row {
            Image {
                id: computer
                source:"../image/computer.png"
            }
            Image {
                id: add
                source:"../image/add.png"
                scale: 0.5
            }
            Image {
                id: wired
                source: "../image/wired.png"
            }
        }
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            id: click
            source: "../image/click.png"
        }
    }
}
