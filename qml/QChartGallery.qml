/* QChartGallery.qml --- 
 * 
 * Author: Julien Wintz
 * Created: Thu Feb 13 23:41:59 2014 (+0100)
 * Version: 
 * Last-Updated: Fri Feb 14 12:58:42 2014 (+0100)
 *           By: Julien Wintz
 *     Update #: 5
 */

/* Change Log:
 * 
 */

import QtQuick 2.5
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import jbQuick.Charts 1.0



import "QChartGallery.js" as ChartsData

Item {
    property var chart_line_data: ChartsData
    property alias chart_line: chart_line

    property int chart_width: parent.width;
    property int chart_height: parent.height;
    property int chart_spacing: 20;
    property int text_height: 80;
    property int row_height: 8;

    Rectangle {

      anchors.fill: parent

      color: "#ffffff";
      width: chart_width + chart_spacing;
      height: chart_height + chart_spacing + row_height + text_height;



    // /////////////////////////////////////////////////////////////////
    // Body
    // /////////////////////////////////////////////////////////////////



      Grid {

        id: layout;

        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width;
        height: parent.height - button.height;

        columns: 1;
        spacing: chart_spacing;

        Chart {
          id: chart_line;
          width: parent.width;
          height: parent.height;
          chartAnimated: true;
          chartAnimationEasing: Easing.Linear;
          chartAnimationDuration: 0;
          chartData: ChartsData.ChartLineData;
          chartType: Charts.ChartType.LINE;
          chartOptions: ChartsData.ChartLineOption;

    //      Rectangle{
    //          anchors.fill:parent
    //          color: "black"
    //          opacity: 0.2
    //      }

        }
      }




// for test
      RowLayout {
        visible: false
        id: inputField
        anchors.left: layout.left
        anchors.top: layout.bottom

        height: 30
        spacing: 5
        Button {
          id: btnStop
          height: parent.height
          text: "Stop"
          onClicked:{
                if( btnStop.text == "Stop"){

                    timer.stop()
                    btnStop.text = "Start"
                }
                else{
                    btnStop.text = "Stop"
                    timer.start()
                }
//              console.log(ChartsData.ChartLineData["datasets"][0]["data"])
//              ChartsData.ChartLineData["datasets"][0]["data"].shift()
//              ChartsData.ChartLineData["datasets"][0]["data"].push(inputText.text)
//              chart_line.repaint()
          }
        }

        Button {
          id: btnAdd
          height: parent.height
          text: "Add"
          onClicked:{
//              console.log(ChartsData.ChartLineData["datasets"][0]["data"])
//              ChartsData.ChartLineData["datasets"][0]["data"].shift()
//              ChartsData.ChartLineData["datasets"][0]["data"].push(inputText.text)
//              chart_line.repaint()
          }
        }
        Label {
            height: parent.height
            text: "Data"
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent.Center
    //        Rectangle{
    //            anchors.fill:parent
    //            color: "black"
    //        }
        }
        TextField{
            id: inputText
            height: parent.height
            text: "30"
        }
      }

    }

}


