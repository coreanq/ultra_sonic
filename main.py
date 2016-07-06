import sys
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication
from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal, QUrl
import qml_rc

if __name__ == "__main__":
    myApp = QApplication(sys.argv)
    qmlEngine = QQmlApplicationEngine()
    qmlEngine.addImportPath("qml")
    qmlEngine.addImportPath("lib")
    rootContext = qmlEngine.rootContext()
    qmlEngine.load(QUrl('qrc:/qml/main.qml'))
    sys.exit(myApp.exec())
    # rootContext.setContextProperty("")

