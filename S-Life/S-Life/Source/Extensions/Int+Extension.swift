//
//  Int+Extension.swift
//  S-Life
//
//  Created by Akhil Mittal on 12/02/22.
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
