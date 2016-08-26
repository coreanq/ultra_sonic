import sys
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication
from PyQt5 import QtCore
from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal, QUrl
from PyQt5.QtCore import QStateMachine, QState, QTimer, QFinalState, QMetaObject
import qml_rc

class UiState(QObject):
    sigComPortOpened = pyqtSignal()
    sigComPortClosed = pyqtSignal()
    sigPowerOn = pyqtSignal()
    sigPowerOff = pyqtSignal()

    def __init__(self):
        super().__init__()
        self.fsm = QStateMachine()
        self.qmlEngine = QQmlApplicationEngine()
        self.qmlEngine.addImportPath("qml")
        self.qmlEngine.addImportPath("lib")
        self.qmlEngine.load(QUrl('qrc:/qml/main.qml'))        
        self.rootObject = self.qmlEngine.rootObjects()[0]

        self.rootObject.comPortOpened.connect(self.sigComPortOpened)
        self.rootObject.comPortClosed.connect(self.sigComPortClosed)
        self.rootObject.powerOn.connect(self.sigPowerOn)
        self.rootObject.powerOff.connect(self.sigPowerOff)
        self.createState()
        pass

    def createState(self):
        # state defintion
        mainState = QState(self.fsm)
        finalState = QFinalState(self.fsm)
        self.fsm.setInitialState(mainState)
        
        initState = QState(mainState)
        openState = QState(mainState)
        mainState.setInitialState(initState)

        standbyState = QState(openState)
        processingState = QState(openState)
        openState.setInitialState(standbyState)

        # transition defition
        initState.addTransition(self.sigComPortOpened, openState) 
        openState.addTransition(self.sigComPortClosed, initState)

        standbyState.addTransition(self.sigPowerOn, processingState)
        processingState.addTransition(self.sigPowerOff, standbyState)

        initState.entered.connect(self.initStateEntered)
        openState.entered.connect(self.openStateEntered)
        standbyState.entered.connect(self.standbyStateEntered)
        processingState.entered.connect(self.processingStateEntered)

        # fsm start
        self.fsm.start()
        pass

    @pyqtSlot()
    def initStateEntered(self):
        print("init")
        QMetaObject.invokeMethod(self.rootObject, "setPathViewIndex", QtCore.Q_ARG("QVariant", 0))
        pass

    @pyqtSlot()   
    def openStateEntered(self):
        print("open")
        pass

    @pyqtSlot()
    def standbyStateEntered(self):
        print("standby")
        QMetaObject.invokeMethod(self.rootObject, "setPathViewIndex", QtCore.Q_ARG("QVariant", 1))
        pass

    @pyqtSlot()
    def processingStateEntered(self):
        print("processing")
        QMetaObject.invokeMethod(self.rootObject, "setPathViewIndex",QtCore.Q_ARG("QVariant", 2))
        pass 

if __name__ == "__main__":
    myApp = QApplication(sys.argv)
    uiState = UiState()
    sys.exit(myApp.exec())

