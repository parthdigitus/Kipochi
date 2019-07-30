//
//  Utilities.swift
//  Kipochi
//
//  Created by Admin on 19/07/19.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation


extension Bundle {
    static var bundle:Bundle {
        let podBundle = Bundle(for: KipochiPaymentController.self)
        
        let bundleURL = podBundle.url(forResource: "Kipochi", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
}



enum CardType: String {
    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
    
    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
    
    var regex : String {
        switch self {
        case .Amex:
            return "^3[47][0-9]{5,}$"
        case .Visa:
            return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
            return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Diners:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPay:
            return "^(62|88)[0-9]{5,}$"
        case .Hipercard:
            return "^(606282|3841)[0-9]{5,}$"
        case .Elo:
            return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
            return ""
        }
    }
}

func matchesRegex(regex: String!, text: String!) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
        let nsString = text as NSString
        let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
        return (match != nil)
    } catch {
        return false
    }
}

extension String {
    
    func replacingOccurrences(of strings:[String], with replacement:String) -> String {
        var newString = self
        for string in strings {
            newString = newString.replacingOccurrences(of: string, with: replacement)
        }
        return newString
    }
    
    func toBase64()->String{
        
        let data = self.data(using: String.Encoding.utf8)
        
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
    }  
}


func luhnCheck(number: String) -> Bool {
    var sum = 0
    let digitStrings = number.reversed().map{String($0)}
    
    for tuple in digitStrings.enumerated() {
        guard let digit = Int(tuple.element) else { return false }
        let odd = tuple.offset % 2 == 1
        
        switch (odd, digit) {
        case (true, 9):
            sum += 9
        case (true, 0...8):
            sum += (digit * 2) % 9
        default:
            sum += digit
        }
    }
    
    return sum % 10 == 0
}

func validate(value: String) -> Bool {
    let monthYearRegix = "^(0?[1-9]|1[012])/([2-9][0-9)]{3})$"
    let Test = NSPredicate(format: "SELF MATCHES %@", monthYearRegix)
    let result =  Test.evaluate(with: value)
    return result
}

extension Date {
    var month: UInt {
        return UInt(Calendar.current.component(.month, from: self))
    }
    
    var year: UInt {
        return UInt(Calendar.current.component(.year, from: self))
    }
}


extension String {
    
    fileprivate static let ANYONE_CHAR_UPPER = "X"
    fileprivate static let ONLY_CHAR_UPPER = "C"
    fileprivate static let ONLY_NUMBER_UPPER = "N"
    fileprivate static let ANYONE_CHAR = "x"
    fileprivate static let ONLY_CHAR = "c"
    fileprivate static let ONLY_NUMBER = "n"
    
    func format(_ format: String, oldString: String) -> String {
        let stringUnformated = self.unformat(format, oldString: oldString)
        var newString = String()
        var counter = 0
        if stringUnformated.count == counter {
            return newString
        }
        for i in 0..<format.count {
            var stringToAdd = ""
            let unicharFormatString = format[i]
            let charFormatString = unicharFormatString
            let charFormatStringUpper = unicharFormatString.uppercased()
            let unicharString = stringUnformated[counter]
            let charString = unicharString
            let charStringUpper = unicharString.uppercased()
            if charFormatString == String.ANYONE_CHAR {
                stringToAdd = charString
                counter += 1
            } else if charFormatString == String.ANYONE_CHAR_UPPER {
                stringToAdd = charStringUpper
                counter += 1
            } else if charFormatString == String.ONLY_CHAR_UPPER {
                counter += 1
                if charStringUpper.isChar() {
                    stringToAdd = charStringUpper
                }
            } else if charFormatString == String.ONLY_CHAR {
                counter += 1
                if charString.isChar() {
                    stringToAdd = charString
                }
            } else if charFormatStringUpper == String.ONLY_NUMBER_UPPER {
                counter += 1
                if charString.isNumber() {
                    stringToAdd = charString
                }
            } else {
                stringToAdd = charFormatString
            }
            
            newString += stringToAdd
            if counter == stringUnformated.count {
                if i == format.count - 2 {
                    let lastUnicharFormatString = format[i + 1]
                    let lastCharFormatStringUpper = lastUnicharFormatString.uppercased()
                    let lasrCharControl = (!(lastCharFormatStringUpper == String.ONLY_CHAR_UPPER) &&
                        !(lastCharFormatStringUpper == String.ONLY_NUMBER_UPPER) &&
                        !(lastCharFormatStringUpper == String.ANYONE_CHAR_UPPER))
                    if lasrCharControl {
                        newString += lastUnicharFormatString
                    }
                }
                break
            }
        }
        return newString
    }
    
    func unformat(_ format: String, oldString: String) -> String {
        var string: String = self
        var undefineChars = [String]()
        for i in 0..<format.count {
            let unicharFormatString = format[i]
            let charFormatString = unicharFormatString
            let charFormatStringUpper = unicharFormatString.uppercased()
            if !(charFormatStringUpper == String.ANYONE_CHAR_UPPER) &&
                !(charFormatStringUpper == String.ONLY_CHAR_UPPER) &&
                !(charFormatStringUpper == String.ONLY_NUMBER_UPPER) {
                var control = false
                for i in 0..<undefineChars.count {
                    if undefineChars[i] == charFormatString {
                        control = true
                    }
                }
                if !control {
                    undefineChars.append(charFormatString)
                }
            }
        }
        if oldString.count - 1 == string.count {
            var changeCharIndex = 0
            for i in 0..<string.count {
                let unicharString = string[i]
                let charString = unicharString
                let unicharString2 = oldString[i]
                let charString2 = unicharString2
                if charString != charString2 {
                    changeCharIndex = i
                    break
                }
            }
            let changedUnicharString = oldString[changeCharIndex]
            let changedCharString = changedUnicharString
            var control = false
            for i in 0..<undefineChars.count {
                if changedCharString == undefineChars[i] {
                    control = true
                    break
                }
            }
            if control {
                var i = changeCharIndex - 1
                while i >= 0 {
                    let findUnicharString = oldString[i]
                    let findCharString = findUnicharString
                    var control2 = false
                    for j in 0..<undefineChars.count {
                        if findCharString == undefineChars[j] {
                            control2 = true
                            break
                        }
                    }
                    if !control2 {
                        string = (oldString as NSString).replacingCharacters(in: NSRange(location: i, length: 1), with: "")
                        break
                    }
                    i -= 1
                }
            }
        }
        for i in 0..<undefineChars.count {
            string = string.replacingOccurrences(of: undefineChars[i], with: "")
        }
        return string
    }
    
    fileprivate func isChar() -> Bool {
        return regexControlString(pattern: "[a-zA-ZğüşöçıİĞÜŞÖÇ]")
    }
    
    fileprivate func isNumber() -> Bool {
        return regexControlString(pattern: "^[0-9]*$")
    }
    
    fileprivate func regexControlString(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let numberOfMatches = regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            return numberOfMatches == self.count
        } catch {
            return false
        }
    }
}

extension String {
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]//self[Range(i ..< i + 1)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        let rangeLast: Range<Index> = start..<end
        return String(self[rangeLast])
    }
}
