import QtQuick 2.7
import QtQuick.Controls 2.0 
import QtQuick.Layouts 1.3
import QtQml.StateMachine 1.0 as DSM
import "firmata"

Rectangle{
    signal sizeChanged()
    id: initWnd
    color: "lightblue"
    clip: true

    Item {
        id: container
        anchors.top : parent.top
        clip: true

        anchors.verticalCenterOffset: parent.height
        width: parent.width
        height: parent.height - label.height
        Rectangle{
            anchors.fill: parent
            color: "black"
            opacity: 0.5
        }
        Rectangle {
            id: focus
            radius: 50
            color: "white"

            Behavior on x {
                NumberAnimation {
                    duration: 1000
                    loops: Animation.Infinite
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: 1000
                    loops: Animation.Infinite
                    easing.type: Easing.InOutQuad
                }
            }

        }

        Column {
            id: column
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Row {
                id: row
                Image {
                    id: computer
                    source: "../image/computer.png"
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
                id: click
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../image/click.png"
           }
        }
    }
    Label {
        id: label
        anchors.top: container.bottom
        width: parent.width
        height: 30
        font.pixelSize: 20
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

    }

    onWidthChanged: {
        sizeChanged()
        row.spacing = parent.width / 10
    }
    onHeightChanged: {
        sizeChanged()
        column.spacing = parent.height / 10
    }


   DSM.StateMachine {
       id: stateMachine
       initialState: computerState
       running: true
       DSM.State {
           id: computerState
           DSM.TimeoutTransition{
               targetState: wiredState
               timeout: 3000
           }
           DSM.SignalTransition{
               targetState: computerState
               signal: initWnd.sizeChanged
           }

           onEntered: {
               focus.width = computer.width * 1.2
               focus.height = computer.height * 1.2
               var transPoint = computer.mapToItem(container, computer.x, computer.y)
               focus.x = transPoint.x - 15
               focus.y = transPoint.y - 15
               label.text = "컴퓨터를 준비"
           }
       }
       DSM.State{
           id: wiredState
           DSM.TimeoutTransition{
               targetState: clickState
               timeout: 3000
           }
          DSM.SignalTransition{
               targetState: wiredState
               signal: initWnd.sizeChanged
           }
           onEntered: {
               focus.width = wired.width * 1.2
               focus.height = wired.height * 1.2
               var transPoint = computer.mapToItem(container, wired.x, wired.y)
               focus.x = transPoint.x - 15
               focus.y = transPoint.y - 15
               label.text = "장비와 컴퓨터를 연결"
           }
       }

       DSM.State{
           id: clickState
           DSM.TimeoutTransition{
               targetState: computerState
               timeout: 3000
           }
           DSM.SignalTransition{
               targetState: clickState
               signal: initWnd.sizeChanged
           }
           onEntered:{
               focus.width = click.width * 1.2
               focus.height = click.height * 1.2
               var transPoint = computer.mapToItem(container, click.x, click.y)
               focus.x = transPoint.x - 10
               focus.y = transPoint.y - 10
               label.text = "Open 을 클릭하여 장비를 활성"
           }

       }

   }
}
