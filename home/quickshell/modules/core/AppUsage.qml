// AppUsage.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int revision: 0
    property var _data: ({})

    readonly property string _path: Quickshell.configDir + "/app_usage.json"

    // Call on startup
    Component.onCompleted: _load()

    function get() {
        return _data
    }

    function record(key) {
        const d = Object.assign({}, _data)
        d[key] = (d[key] || 0) + 1
        _data = d
        revision++
        _save()
    }

    function _save() {
        fileView.setText(JSON.stringify(_data))
    }

    function _load() {
        fileView.reload()
    }

    function clear() {
        _data = {}
        revision++
        _save()
    }

    FileView {
        id: fileView
        path: root._path
        blockLoading: true

        onTextChanged: {
            try {
                root._data = JSON.parse(fileView.text())
                root.revision++
            } catch (e) {
                root._data = {}
            }
        }
    }
}
