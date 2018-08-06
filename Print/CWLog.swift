//
//  CWLog.swift
//  Print
//
//  Created by chenwang on 2018/5/30.
//  Copyright © 2018年 罗泰. All rights reserved.
//

import Foundation

protocol LogLevel {
    func myDescription(level: Int) -> String
}

//封装的日志输出功能（T表示不指定日志信息参数类型）
func CWLog<T>(_ message:T, file:String = #file, function:String = #function,
              line:Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    if message is Dictionary<String, Any> {
        print("[\(fileName):line:\(line)]- \((message as! Dictionary<String, Any>).myDescription(level: 0))")
    }else if message is Array<Any> {
        print("[\(fileName):line:\(line)]- \((message as! Array<Any> ).myDescription(level: 0))")
    }else if message is CustomStringConvertible {
        print("[\(fileName):line:\(line)]- \((message as! CustomStringConvertible).description)")
    }else {
        print("[\(fileName):line:\(line)]- \(message)")
    }
    #endif
}


// MARK: - 重写可选型description
extension Optional: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "Optional(null)"
        case .some(let obj):
            if let obj = obj as? CustomStringConvertible, obj is Dictionary<String, Any> {
                return "Optional:" + "\((obj as! Dictionary<String, Any>).myDescription(level: 0))"
            }
            if let obj = obj as? CustomStringConvertible, obj is Array<Any> {
                return "Optional:" + "\((obj as! Array<Any>).myDescription(level: 0))"
            }
            return  "Optional" + "(\(obj))"
        }
    }
}

// MARK: - 重写字典型description
extension Dictionary: LogLevel {
    public var description: String {
        var str = ""
        str.append(contentsOf: "{\n")
        for (key, value) in self {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, s.unicodeStr))
            }else if value is Dictionary {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, (value as! Dictionary).description))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, (value as! Array<Any>).description))
            }else {
                str.append(contentsOf: String.init(format: "\t%@ = \"%@\",\n", key as! CVarArg, "\(value)"))
            }
        }
        str.append(contentsOf: "}")
        return str
    }
    
    func myDescription(level: Int) -> String{
        var str = ""
        var tab = ""
        for _ in 0..<level {
            tab.append(contentsOf: "\t")
        }
        str.append(contentsOf: "{\n")
        for (key, value) in self {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "%@\t%@ = \"%@\",\n", tab, key as! CVarArg, s.unicodeStrWith(level: level)))
            }else if value is Dictionary {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, (value as! Dictionary).myDescription(level: level + 1)))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, (value as! Array<Any>).myDescription(level: level + 1)))
            }else {
                str.append(contentsOf: String.init(format: "%@\t%@ = %@,\n", tab, key as! CVarArg, "\(value)"))
            }
        }
        str.append(contentsOf: String.init(format: "%@}", tab))
        return str
    }
}

extension Array: LogLevel {
    func myDescription(level: Int) -> String {
        var str = ""
        var tab = ""
        str.append(contentsOf: "[\n")
        for _ in 0..<level {
            tab.append(contentsOf: "\t")
        }
        for (_, value) in self.enumerated() {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "%@\t\"%@\",\n", tab, s.unicodeStrWith(level: level)))
            }else if value is Dictionary<String, Any> {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, (value as! Dictionary<String, Any>).myDescription(level: level + 1)))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, (value as! Array<Any>).myDescription(level: level + 1)))
            }else {
                str.append(contentsOf: String.init(format: "%@\t%@,\n", tab, "\(value)"))
            }
        }
        str.append(contentsOf: String.init(format: "%@]", tab))
        return str
    }
    
    public var description: String {
        var str = ""
        str.append(contentsOf: "[\n")
        for (_, value) in self.enumerated() {
            if value is String {
                let s = value as! String
                str.append(contentsOf: String.init(format: "\t\"%@\",\n", s.unicodeStr))
            }else if value is Dictionary<String, Any> {
                str.append(contentsOf: String.init(format: "\t%@,\n", (value as! Dictionary<String, Any>).description))
            }else if value is Array<Any> {
                str.append(contentsOf: String.init(format: "\t%@,\n", (value as! Array<Any>).description))
            }else {
                str.append(contentsOf: String.init(format: "\t%@,\n", "\(value)"))
            }
        }
        str.append(contentsOf: "]")
        return str
    }
}

// MARK: - unicode转码
extension String {
    func unicodeStrWith(level: Int) -> String {
        let s = self
        let data = s.data(using: .utf8)
        if let data = data {
            if let id = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                if id is Array<Any> {
                    return (id as! Array<Any>).myDescription(level: level + 1)
                }else if id is Dictionary<String, Any> {
                    return (id as! Dictionary<String, Any>).myDescription(level: level + 1)
                }
            }
        }
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    var unicodeStr:String {
        return self.unicodeStrWith(level: 1)
    }
}
