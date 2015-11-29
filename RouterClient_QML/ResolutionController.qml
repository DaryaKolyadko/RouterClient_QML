import QtQuick 2.0
import QtQuick.Window 2.0

Item {
    property int dpi: Screen.pixelDensity * 25.4

    function dp(x){
        if(dpi < 120) {
            return x; // Для обычного монитора компьютера
        } else {
            return x*(dpi/160);
        }
    }
}
