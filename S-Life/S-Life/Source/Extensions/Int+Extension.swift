//
//  Int+Extension.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 12/09/21.
//

import Foundation

extension Int {
    var ordinal: String? {
        return ordinalFormatter.string(from: NSNumber(value: self))
    }
}

private var ordinalFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en")
    formatter.numberStyle = .ordinal
    return formatter
}()
