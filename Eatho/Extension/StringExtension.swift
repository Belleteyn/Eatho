//
//  StringExtension.swift
//  Eatho
//
//  Created by Серафима Зыкова on 10/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var attributed: NSAttributedString {
        do {
            return try NSAttributedString.init(data: self.data(using: String.Encoding.utf8)!, options: [NSAttributedString.DocumentReadingOptionKey.characterEncoding : String.Encoding.utf8.rawValue, NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
      } catch {
        return NSAttributedString.init(string: self)
      }
    }
}
