import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0
import Firmata 1.0

RowLayout {
    signal dataReceived(int rawValue)
    signal switchChanged(int state)
    signal portOpened()
    signal portClosed()

    function openPort(portName) {
        firmata.backend.device = portName;
    }
    function closePort(){
        firmata.backend.device = "";
    }

    Firmata{
        id: firmata
        backend: SerialFirmata{
            baudRate: 115200
            onAvailabilityChanged: {
               if( available == true )
                   portOpened()
               else
                   portClosed()
            }
        }
        AnalogPin {
            channel: 7
            pin:7
            onSampled: {
                dataReceived(rawValue)
            }
        }
        AnalogPin{
            channel: 3
            pin: 3
            onSampled: {
                switchChanged(rawValue)
            }

        }
    }
    Button{
        id: btnOpen
        width: 50
        text: "Open"
        onClicked: {
            if( text == "Open" ){
               text = "Close"
               openPort(cmbPortName.currentText)
                cmbPortName.enabled = false
            }
            else {
                text = "Open"
                cmbPortName.enabled = true
                closePort()
            }

            text: "Close"
        }
    }
    ComboBox {
        id: cmbPortName
        model: SerialPortList
        textRole: "name"
    }



	Label {
        width: parent.width / 10
		text: firmata.statusText
	}
}

