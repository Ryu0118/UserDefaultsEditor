import Foundation
import EditValueView
import SwiftUI

enum UserDefaultsType {
    case string(String)
    case array([Any])
    case dictionary([String: Any])
    case data(Data)
    case stringArray([String])
    case integer(Int)
    case float(Float)
    case double(Double)
    case bool(Bool)
    case url(URL)
    case date(Date)
    case object(Any)

    var description: String {
        switch self {
        case .string(let string):
            string.description
        case .array(let array):
            array.description
        case .dictionary(let dictionary):
            dictionary.description
        case .data(let data):
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]),
               let jsonString = String(data: jsonData, encoding: .utf8)
            {
                jsonString
            } else if let string = String(data: data, encoding: .utf8) {
                string
            } else {
                data.description
            }
        case .stringArray(let array):
            array.description
        case .integer(let int):
            int.description
        case .float(let float):
            float.description
        case .double(let double):
            double.description
        case .bool(let bool):
            bool.description
        case .url(let url):
            url.description
        case .date(let date):
            date.description
        case .object(let any):
            String(reflecting: any)
        }
    }

    static func identify(_ value: Any) -> Self {
        switch value {
        case let string as String:
            return .string(string)
        case let stringArray as [String]:
            return .stringArray(stringArray)
        case let array as [Any]:
            return .array(array)
        case let dictionary as [String: Any]:
            return .dictionary(dictionary)
        case let data as Data:
            return .data(data)
        case let integer as Int:
            return .integer(integer)
        case let float as Float:
            return .float(float)
        case let double as Double:
            return .double(double)
        case let bool as Bool:
            return .bool(bool)
        case let url as URL:
            return .url(url)
        case let date as Date:
            return .date(date)
        default:
            return .object(value)
        }
    }
}

struct UserDefaultsRepresentation: Identifiable {
   var id: String {
       key
   }
   let key: String
   let type: UserDefaultsType
}
