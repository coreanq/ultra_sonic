import QtQuick 2.7
import QtQuick.Controls 2.0 
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4

Rectangle{
    id: main
    anchors.fill: parent

    color: "blue"

    ListModel {
        id: viewModel
        ListElement {
            qmlName: "InitWnd.qml"
        }
        ListElement {
            qmlName: "ProcessingWnd.qml"
        }
        ListElement {
            qmlName: "StandbyWnd.qml"
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
//    Rectangle{
//        anchors.left: parent.left
//        width: 580
//        height: 180
//        color: "yellow"
//        opacity: 0.5
//        z: 100

//    }

    PathView {
        id: pathView
        anchors.fill: parent
        model: viewModel
        delegate: delegate
        path: Path {
            startX: parent.width /2
            startY: parent.height /2
            PathQuad { x: parent.width / 2; y: -parent.height * 0.1; controlX: parent.width * 1.1 ; controlY: parent.height/2 }
            PathQuad { x: parent.width / 2; y: parent.height /2; controlX: -parent.width * 0.1; controlY: parent.height/2 }
        }
    }
}


