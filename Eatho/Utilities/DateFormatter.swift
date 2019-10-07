//
//  DateFormatter.swift
//  Eatho
//
//  Created by Серафима Зыкова on 05/09/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

class EathoDateFormatter {
    static let instance = EathoDateFormatter()
    
    private let dateFormatter = DateFormatter()
    private let isoFormatter = ISO8601DateFormatter()
    
    init() {
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
    }
    
    func format(isoDate date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func format(isoDate date: String) -> String? {
        guard let date = isoFormatter.date(from: "\(date)") else { return nil }
        return format(isoDate: date)
    }
    
    func date(fromString string: String) -> Date? {
        return isoFormatter.date(from: string)
    }
}
