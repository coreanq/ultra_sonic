import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4
import QtQml 2.2
import "firmata"
import QtQml.StateMachine 1.0 as DSM

ApplicationWindow{
    signal comDataReceived(int rawValue)
    signal comPortOpened()
    signal comPortClosed()
    signal powerOn()
    signal powerOff()
    id: mainWnd

    visible: true
    width: 800
    height: 640
    title: "도어열림감지센서"

    function setPathViewIndex(index){
        while(1){
            if( pathView.currentIndex == index){
                break;
            }
            pathView.incrementCurrentIndex()
        }
    }

    PortSelector {
        id: port
        anchors.top: parent.top
        width: parent.width
        height: 40
        clip: true
        onDataReceived: {
//            console.log("!")
            comDataReceived(rawValue)
        }
        onPortOpened:  {
           comPortOpened()
        }
        onPortClosed:  {
            comPortClosed()
        }
        onSwitchChanged: {
            if( state == 1 )
                powerOn()
            else if( state == 0)
                powerOff()
        }
    }
    VisualItemModel{
       id: itemModel

       Flipable {
            id: _initWnd
            width: parent.width / 10  * 8
            height: parent.height / 10 * 8
            z: pathView.currentItem == _initWnd ? 0 : -1
            scale: pathView.currentItem == _initWnd ? 1: 0.5

            property bool flipped: false

            front: InitWnd{ anchors.fill: parent}
            back: Image {
                    source: "../image/card_back.jpg";
                    anchors.fill: parent;
            }


            transform: Rotation {
                id: _rotationInitWnd
                origin.x: _initWnd.width/2
                origin.y: _initWnd.height/2
                axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                angle: 0    // the default angle
            }

            states: State {
                name: "back"
                PropertyChanges { target: _rotationInitWnd; angle: 180 }
                when: _initWnd.flipped
            }

            transitions: Transition {
                NumberAnimation { target: _rotationInitWnd; property: "angle"; duration: 800 }
            }
        }

       Flipable {
            id: _standbyWnd
            width: parent.width / 10  * 8
            height: parent.height / 10 * 8
            z: pathView.currentItem == _standbyWnd ? 0 : -1
            scale: pathView.currentItem == _standbyWnd ? 1: 0.5

            property bool flipped: true

            front: StandbyWnd{ anchors.fill: parent}
            back: Image {
                    source: "../image/card_back.jpg";
                    anchors.fill: parent;
            }


            transform: Rotation {
                id: _rotationStandby
                origin.x: _standbyWnd.width/2
                origin.y: _standbyWnd.height/2
                axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                angle: 0    // the default angle
            }

            states: State {
                name: "back"
                PropertyChanges { target: _rotationStandby; angle: 180 }
                when: _standbyWnd.flipped
            }

            transitions: Transition {
                NumberAnimation { target: _rotationStandby; property: "angle"; duration: 800 }
            }
        }
       Flipable {
            id: _processingWnd
            width: parent.width / 10  * 8
            height: parent.height / 10 * 8
            z: pathView.currentItem == _processingWnd ? 0 : -1
            scale: pathView.currentItem == _processingWnd ? 1: 0.5

            property bool flipped: true

            front: ProcessingWnd{ anchors.fill: parent}
            back: Image {
                    source: "../image/card_back.jpg";
                    anchors.fill: parent;
            }


            transform: Rotation {
                id: _rotationProcessing
                origin.x: _processingWnd.width/2
                origin.y: _processingWnd.height/2
                axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                angle: 0    // the default angle
            }

            states: State {
                name: "back"
                PropertyChanges { target: _rotationProcessing; angle: 180 }
                when: _processingWnd.flipped
            }

            transitions: Transition {
                NumberAnimation { target: _rotationProcessing; property: "angle"; duration: 800 }
            }
        }

    }
    Image {
        source: "../image/background.jpg"
        anchors.fill: parent; clip: true
        z: -1
    }
    PathView {
        id: pathView
        anchors.top: port.bottom
        width: parent.width
        height: parent.height - port.height
        model: itemModel
        interactive: false
        flickDeceleration: 20
        clip: true
        path: Path {
            startX: mainWnd.width /2
            startY: mainWnd.height /2
            PathQuad { x: mainWnd.width / 2; y: -mainWnd.height * 0.1; controlX: mainWnd.width * 1.1 ; controlY: mainWnd.height/2 }
            PathQuad { x: mainWnd.width / 2; y: mainWnd.height /2; controlX: -mainWnd.width * 0.1; controlY: mainWnd.height/2 }
        }
        onCurrentIndexChanged: {
            switch( currentIndex )
            {
            case 0:
                _initWnd.flipped = false
                _standbyWnd.flipped = true
                _processingWnd.flipped = true
                break;
            case 1:
                _initWnd.flipped = true
                _standbyWnd.flipped = false
                _processingWnd.flipped = true
                break;
            case 2:
                _initWnd.flipped = true
                _standbyWnd.flipped = true
                _processingWnd.flipped = false
                break;
            }
        }

    }

   DSM.StateMachine {
       id: mainStateMachine
       initialState: initState
       running: true
       DSM.State {
           id: initState
           DSM.SignalTransition{
               targetState: openState
               signal: comPortOpened
           }
           onEntered: {
//             setPathViewIndex(0)
           }
       }
       DSM.State {
          id: openState
          initialState: standbyState
          DSM.SignalTransition{
             targetState: initState
             signal: comPortClosed
          }

          DSM.State{
              id: standbyState
              DSM.SignalTransition{
                  targetState: processingState
                  signal:  powerOn
               }
               onEntered: {
//                   setPathViewIndex(1)
               }
           }
           DSM.State{
               id: processingState
               DSM.SignalTransition{
                   targetState: standbyState
                   signal: powerOff
               }
               onEntered: {
//                   setPathViewIndex(2)

               }
           }
       }
   }

}


