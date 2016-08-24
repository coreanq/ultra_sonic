import QtQuick 2.7
import QtQuick.Controls 2.0 
import QtQuick.Layouts 1.3
import QtQml.StateMachine 1.0 as DSM

Rectangle{
    id: standbyWnd
    color: "yellow"
    opacity: 0.5
    clip: true
    Item {
        id: container
        width: parent.width
        height: parent.height - label.height

        Image {
            id: switchOn
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source:"../image/switch.png"
            scale: 1.5
            Behavior on y {
               NumberAnimation {
                   duration: 1000
                   loops: Animation.Infinite
                   easing.type: Easing.InOutQuad
               }
           }
        }
        Image {
            id: click
            x: parent.x
            y: parent.height - click.paintedHeight * 1.5
            source: "../image/click.png"
            scale: 1.5
            Behavior on y {
               NumberAnimation {
               duration: 1000
               loops: Animation.Infinite
               easing.type: Easing.InOutQuad
               }
           }
        }

    }

    Label {
        id: label
        anchors.top: container.bottom
        width: parent.width
        height: 30
        text: "장비의 전원을 켜주세요"
        font.pixelSize: 20
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    DSM.StateMachine {
        id: stateMachine
        initialState: initState
        running: true
        DSM.State {
            id: initState
            DSM.TimeoutTransition{
                targetState: clickedState
                timeout: 2000
            }
            onEntered: {
                switchOn.visible =  true
                click.x = switchOn.x  + 15
                click.y = switchOn.y + (switchOn.paintedWidth * 1.5 ) / 2
            }
            onExited: {
            }
        }
        DSM.State {
            id: clickedState
            DSM.TimeoutTransition{
                targetState: initState
                timeout: 2000
            }
            onEntered: {
                click.x = switchOn.x + 15
                click.y = container.y + container.height + 200
            }
            onExited: {
            }
        }

     }


//              easing {type: Easing.OutBack; overshoot: 500}
//         }
}

