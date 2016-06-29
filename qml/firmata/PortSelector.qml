import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import Firmata 1.0

RowLayout {
    signal dataReceived(int rawValue)

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
        }
        AnalogPin {
            channel: 7
            pin:7
            onSampled: {
                dataReceived(rawValue)
            }


        }
    }

    ComboBox {
        id: cmbPortName
		model: SerialPortList
		textRole: "name"
    }

    Button{
        id: btnOpen
        text: "Open"
        onClicked: {
            if( text == "Open" ){
               text = "Close"
               openPort(cmbPortName.currentText)
            }
            else {
                text = "Open"
                closePort()
            }

            text: "Close"
        }
    }

	Label {
		text: firmata.statusText
	}
}

