//
//  PdfCreator.swift
//  Eatho
//
//  Created by Серафима Зыкова on 16/10/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import UIKit
import PDFKit
import TPPDF

class PdfCreator {
    static let instance = PdfCreator()
    
    func createDocument(title: String) -> URL? {
        
        let document = PDFDocument(format: .a4)
        document.add(.contentCenter, text: "Create PDF documents easily.")
        
        do {
            let doc = try PDFGenerator.generateURL(document: document, filename: "Example.pdf")
            print(doc)
            
            return doc
        } catch {
            debugPrint(error)
        }
        
        return nil
    }
}
