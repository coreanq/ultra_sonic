import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4
import QtQml 2.2
import "firmata"
ApplicationWindow{
    id: main
    signal portOpened()
    signal portClosed()
    visible: true
    width: 640
    height: 480
    title: ""

//    ListModel {
//        id: viewModel
//        ListElement {
//            qmlName: "InitWnd.qml"
//        }
//      ListElement {
//            qmlName: "StandbyWnd.qml"
//        }

//        ListElement {
//            qmlName: "ProcessingWnd.qml"
//        }
//      }
    VisualItemModel{
       id: itemModel
       InitWnd{
           id: initWnd
            width: parent.width / 10  * 8
            height: parent.height / 10 * 8
            z: pathView.currentItem == initWnd ? 0 : -1
            opacity: pathView.currentItem == initWnd? 1: 0.5
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

    Component {
        id: delegate
        Loader {
            id: wnd
            source: qmlName
            width: parent.width / 10  * 8
            height: parent.height / 10 * 8
            z: wnd.PathView.isCurrentItem ? 0 : -1
            opacity: wnd.PathView.isCurrentItem ? 1: 0.5
            scale: wnd.PathView.isCurrentItem ? 1: 0.5
        }
    }
//    onPortOpened:{
//        console.log("open")
//    }
//    onPortClosed:{
//        console.log("close")
//    }


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
        onCurrentItemChanged:{
            currentItem.scale = 1

        }
    }
}


