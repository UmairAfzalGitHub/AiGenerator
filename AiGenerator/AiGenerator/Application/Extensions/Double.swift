
import Foundation

extension Double {

    func timeStringFromUnixTime(dateFormatter: DateFormatter, deviderValue: Double = 1) -> String {
        let date = Date(timeIntervalSince1970: self/deviderValue)
        return dateFormatter.string(from: date)
    }
    
    func toDoubleString() -> String {
        return String(format: "%.2f", self)
    }
    
    func toString() -> String {
        return String(self)
    }
}
