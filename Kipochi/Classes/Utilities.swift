//
//  Utilities.swift
//  ProgamaticallyTableView
//
//  Created by Admin on 19/07/19.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

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
