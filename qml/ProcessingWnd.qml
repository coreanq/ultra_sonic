import QtQuick 2.7
import QtQuick.Controls 2.0 
import QtQuick.Layouts 1.3
import "firmata"

Rectangle{
    id: processingWnd
    color: "black"

    Connections	{
        target: mainWnd
        onComDataReceived:{
//            console.log("%")
            dataUpdate(rawValue)
        }
        onComSwitchChanged:{
            console.log(state)
        }
    }

    QChartGallery{
        id: gallery
        anchors.fill: parent
        anchors.margins: 5
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

