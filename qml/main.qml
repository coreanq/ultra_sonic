import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "firmata"

ApplicationWindow{
    id: main
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    PortSelector {
        id: port
        anchors.top: main.top
        height:40
        width: main.width
        Rectangle {
            visible: false
            anchors.fill: parent
            color: "black"
            opacity: 0.5
        }

        Component.onCompleted: {

        }
        onDataReceived: {
            dataUpdate(rawValue)
        }



    }
    QChartGallery{
        id: gallery
        anchors.left: main.left
        anchors.top: port.bottom
        width: main.width
        height: main.height - port.height

        Rectangle{
            visible: false
            anchors.fill: parent
            color: "green"
            opacity: 0.5
        }
    }
    Timer {
        id: timer
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            var d = new Date()
            gallery.chart_line_data.ChartLineData["labels"].shift()
            gallery.chart_line_data.ChartLineData["labels"].push(d.getSeconds() + "." + d.getMilliseconds() )
            gallery.chart_line_data.ChartLineData["datasets"][0]["data"].shift()
            gallery.chart_line_data.ChartLineData["datasets"][0]["data"].push(Math.floor(Math.random() * 400 +1 ).toString())
            gallery.chart_line_data.ChartLineData["datasets"][1]["data"].shift()
            gallery.chart_line_data.ChartLineData["datasets"][1]["data"].push(Math.floor(Math.random() * 400 +1 ).toString())
            gallery.chart_line.repaint()

        }
    }
    function dataUpdate(rawValue){
        var d = new Date()
        gallery.chart_line_data.ChartLineData["labels"].shift()
        gallery.chart_line_data.ChartLineData["labels"].push(d.getSeconds() + "." + d.getMilliseconds() )
        gallery.chart_line_data.ChartLineData["datasets"][0]["data"].shift()
        gallery.chart_line_data.ChartLineData["datasets"][0]["data"].push(rawValue.toString())
//        gallery.chart_line_data.ChartLineData["datasets"][1]["data"].shift()
//        gallery.chart_line_data.ChartLineData["datasets"][1]["data"].push(Math.floor(Math.random() * 400 +1 ).toString())
        gallery.chart_line.repaint()

    }
}


//    footer: TabBar {
//        id: tabBar
//        currentIndex: swipeView.currentIndex
//        TabButton {
//            text: qsTr("First")
//        }
//        TabButton {
//            text: qsTr("Second")
//        }
//    }
