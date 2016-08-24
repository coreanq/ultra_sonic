import QtQuick 2.7
import QtQuick.Controls 2.0 
import QtQuick.Layouts 1.3
import "firmata"

Rectangle{
    id: main

    QChartGallery{
        id: gallery
        anchors.left: main.left
        anchors.top: port.bottom
        width: main.width
        height: main.height

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

