import QtQuick 2.7
import QtQuick.Controls 2.0 
import QtQuick.Layouts 1.3
import QtQml.StateMachine 1.0 as DSM
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
        width: parent.width
        height: 40
        clip: true
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
        }
        onPortClosed:  {
            back.visible = false
        }

    }
    Item {
        id: container
        anchors.verticalCenter: initWnd.verticalCenter
        anchors.verticalCenterOffset: port.height
        anchors.horizontalCenter: initWnd.horizontalCenter
        width: parent.width
        height: parent.height - port.height
        Rectangle{
            anchors.fill: parent
            color: "black"
            opacity: 0.5
        }

        Image {
            id: computer
            anchors.left: parent.left
            anchors.rightMargin: (parent.width - computer.sourceSize.width - add.sourceSize.width - wired.sourceSize.width)/2
            source:"../image/computer.png"
            Behavior on scale {
                NumberAnimation {
                    duration: 1000
                    loops: Animation.Infinite
                    easing.type: Easing.InOutBounce
                }

            }
        }

        Image {
            id: add
            anchors.left: computer.right
            source:"../image/add.png"
            scale: 0.5
            Behavior on scale {
                NumberAnimation {
                    duration: 1000
                    loops: Animation.Infinite
                    easing.type: Easing.InOutBounce
                }

            }
        }
        Image {
            id: wired
            anchors.left: add.right
            source: "../image/wired.png"
            Behavior on scale {
                NumberAnimation {
                    duration: 1000
                    loops: Animation.Infinite
                    easing.type: Easing.InOutBounce
                }

            }
        }
        Image {
            anchors.top: computer.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            id: click
            source: "../image/click.png"
            Behavior on scale {
                NumberAnimation {
                    duration: 1000
                    loops: Animation.Infinite
                    easing.type: Easing.InOutBounce
                }

            }
        }
    }


   DSM.StateMachine {
       id: stateMachine
       initialState: computerState
       running: true
       DSM.State {
           id: computerState
           DSM.TimeoutTransition{
               targetState: addState
               timeout: 2000
           }
           onEntered: {
               computer.scale = 1.5
           }
           onExited: {
               computer.scale = 1
           }
       }
       DSM.State{
           id: addState
           DSM.TimeoutTransition{
               targetState: wiredState
               timeout: 2000
           }
           onEntered: {
               add.scale =  1
           }
           onExited: {
               add.scale = 0.5
           }
       }
       DSM.State{
           id: wiredState
           DSM.TimeoutTransition{
               targetState: clickState
               timeout: 2000
           }
           onEntered: {
               wired.scale = 1.5
           }
           onExited: {
               wired.scale = 1
           }
       }

       DSM.State{
           id: clickState
           DSM.TimeoutTransition{
               targetState: computerState
               timeout: 2000
           }
           onEntered:{
               click.scale = 1.5
           }
           onExited: {
               click.scale = 1
           }

       }

   }
}
