import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4
import QtQml 2.2
import "firmata"
import QtQml.StateMachine 1.0 as DSM

ApplicationWindow{
    signal sgInit()
    signal sgStandby()
    signal sgProcessing()
    id: main

    visible: true
    width: 800
    height: 640
    title: "IOT 도어열림알림센서"

    Connections {
        target: initWnd
        onComPortOpened:{
            console.log("open")
            sgStandby()
        }

        onComPortClosed:{
            console.log("close")
            sgInit()
        }

    }

    VisualItemModel{
       id: itemModel
       InitWnd{
           id: initWnd
            width: parent.width / 10  * 8
            height: parent.height / 10 * 8
            z: pathView.currentItem == initWnd ? 0 : -1
            opacity: pathView.currentItem == initWnd ? 1: 0.5
            scale: pathView.currentItem == initWnd ? 1: 0.5
       }
       StandbyWnd{
           id: standbyWnd
             width: parent.width / 10  * 8
            height: parent.height / 10 * 8
            z: pathView.currentItem == standbyWnd? 0 : -1
            opacity: pathView.currentItem == standbyWnd ? 1: 0.5
            scale:  pathView.currentItem == standbyWnd ? 1: 0.5

       }
       ProcessingWnd{
           id: processingWnd
            width: parent.width / 10  * 8
            height: parent.height / 10 * 8
            z: pathView.currentItem == processingWnd ? 0 : -1
            opacity: pathView.currentItem == processingWnd ? 1: 0.5
            scale: pathView.currentItem == processingWnd ? 1: 0.5

       }
    }

    PathView {
        id: pathView
        anchors.fill: parent
        model: itemModel
        path: Path {
            startX: main.width /2
            startY: main.height /2
            PathQuad { x: main.width / 2; y: -main.height * 0.1; controlX: main.width * 1.1 ; controlY: main.height/2 }
            PathQuad { x: main.width / 2; y: main.height /2; controlX: -main.width * 0.1; controlY: main.height/2 }
        }
    }
    DSM.StateMachine {
       id: stateMachine
       initialState: initState
       running: true
       DSM.State {
           id: initState
           DSM.SignalTransition{
               targetState: standbyState
               signal: main.sgStandby
           }
           onEntered: {
               pathView.incrementCurrentIndex()
           }
           onExited: {
           }
       }
       DSM.State {
           id: standbyState
           DSM.SignalTransition{
               targetState: processingState
               signal: sgProcessing
           }
           DSM.SignalTransition{
               targetState: initState
               signal: main.sgInit
           }

           onEntered: {

           }
           onExited: {
           }
       }
       DSM.State {
           id: processingState
           DSM.SignalTransition{
               targetState: initState
               signal: main.sgInit
           }
           onEntered:{

           }
           onExited: {

           }
       }

    }
}


