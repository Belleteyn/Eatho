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
    
    func createDocument(title: String, username: String, ration: [FoodItem]) -> (Data?, Error?) {
        
        let titleFont = UIFont(name: "Avenir", size: 20) ?? UIFont.systemFont(ofSize: 20)
        let headerFont = UIFont(name: "Avenir", size: 11) ?? UIFont.systemFont(ofSize: 11)
        
        let document = PDFDocument(format: .a4)
        document.info.title = title
        document.info.author = "EathoApp"
        
        document.add(.headerRight, attributedText: NSAttributedString(string: username, attributes: [NSAttributedString.Key.foregroundColor : TEXT_COLOR, NSAttributedString.Key.font: headerFont]))
        document.add(.headerLeft, attributedText: NSAttributedString(string: "EathoApp", attributes: [NSAttributedString.Key.foregroundColor : TEXT_COLOR, NSAttributedString.Key.font: headerFont]))
        document.add(.contentCenter, attributedText: NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : TEXT_COLOR, NSAttributedString.Key.font : titleFont]))
        document.add(space: 12)
        
        let table = customizedTable()
        let data = createData(ration: ration)
        
        let defaultAlignment: [PDFTableCellAlignment] = [.left, .left, .left, .left, .left, .left, .left, .left, .left]
        let alignments: [[PDFTableCellAlignment]] = Array.init(repeating: defaultAlignment, count: data.count)
        
        do {
            try table.generateCells(data: data, alignments: alignments)
        } catch {
            return (nil, error)
        }

        table.widths = [0.2, 0.11, 0.11, 0.11, 0.11, 0.09, 0.09, 0.11, 0.07]
        document.add(table: table)
        
        do {
            let doc = try PDFGenerator.generateData(document: document)
            return (doc, nil)
        } catch {
            return (nil, error)
        }
    }
    
    private func customizedTable() -> PDFTable {
        let lineStyle = PDFLineStyle(type: .full, color: UIColor.white, width: 0)
        let borders = PDFTableCellBorders(left: lineStyle, top: lineStyle, right: lineStyle, bottom: lineStyle)
        
        let headerFont = UIFont(name: "Avenir", size: 9) ?? UIFont.systemFont(ofSize: 9)
        let dataFont = UIFont(name: "Avenir", size: 11) ?? UIFont.systemFont(ofSize: 11)
        
        let table = PDFTable()
        table.style.rowHeaderCount = 0
        table.style.columnHeaderCount = 1
        table.style.footerCount = 1
        table.style.outline.width = 0
        table.padding = 4
        
        table.style.columnHeaderStyle.colors = (fill: EATHO_MAIN_COLOR, text: UIColor.white)
        table.style.columnHeaderStyle.font = headerFont
        table.style.columnHeaderStyle.borders = borders
        
        table.style.footerStyle.colors = (fill: EATHO_LIGHT_PURPLE, text: UIColor.white)
        table.style.footerStyle.font = dataFont
        table.style.footerStyle.borders = borders
        
        let cellStyle = PDFTableCellStyle(colors: (fill: UIColor.white, text: TEXT_COLOR), borders: borders, font: dataFont)
        table.style.contentStyle = cellStyle
        table.style.alternatingContentStyle = cellStyle
        
        
        return table
    }
    
    private func createData(ration: [FoodItem]) -> [[Any]] {
        var data: [[Any]] = [["Name".localized, "Portion".localized, "Calories".localized, "Proteins".localized, "Carbs".localized, "Sugars".localized, "Fiber".localized, "Fats".localized, "Trans".localized]]
        
        var summation: [Double] = [0, 0, 0, 0, 0, 0, 0]
        
        for food in ration {
            data.append(fetchFood(food: food, summation: &summation))
        }
        
        data.append(["Overall".localized, "", "\(summation[0].truncated()) \(KCAL)", "\(summation[1].truncated()) \(G)", "\(summation[2].truncated()) \(G)", "\(summation[3].truncated()) \(G)", "\(summation[4].truncated()) \(G)", "\(summation[5].truncated()) \(G)", "\(summation[6].truncated()) \(G)"])
        
        return data
    }
    
    private func fetchFood(food: FoodItem, summation: inout [Double]) -> [String] {
        var data = [String]()
        
        let name = food.food?.name ?? ""
        let portion = food.portion ?? 0
        let calories = food.food?.nutrition.calories.total ?? 0
        let proteins = food.food?.nutrition.proteins ?? 0
        let carbs = food.food?.nutrition.carbs.total ?? 0
        let sugars = food.food?.nutrition.carbs.sugars
        let fiber = food.food?.nutrition.carbs.dietaryFiber
        let fats = food.food?.nutrition.fats.total ?? 0
        let trans = food.food?.nutrition.fats.trans
        
        let caloriesPerPortion = calories / 100.0 * portion
        let proteinsPerPortion = proteins / 100.0 * portion
        let carbsPerPortion = carbs / 100.0 * portion
        let fatsPerPortion = fats / 100.0 * portion
        let sugarsPerPortion = sugars != nil ? (sugars! / 100.0 * portion) : nil
        let fiberPerPortion = fiber != nil ? fiber! / 100.0 * portion : nil
        let transPerPortion = trans != nil ? trans! / 100.0 * portion : nil
        
        data.append(name)
        if SettingsService.instance.userInfo.lbsMetrics {
            data.append("\(convertMetrics(g: portion).truncated()) \(LB)")
        } else {
            data.append("\(portion.truncated()) \(G)")
        }
        data.append("\(caloriesPerPortion.truncated()) \(KCAL)")
        data.append("\(proteinsPerPortion.truncated()) \(G)")
        data.append("\(carbsPerPortion.truncated()) \(G)")
        sugarsPerPortion != nil ? data.append("\(sugarsPerPortion!.truncated()) \(G)") : data.append("")
        fiberPerPortion != nil ? data.append("\(fiberPerPortion!.truncated()) \(G)") : data.append("")
        data.append("\(fatsPerPortion.truncated()) \(G)")
        transPerPortion != nil ? data.append("\(transPerPortion!.truncated()) \(G)") : data.append("")
        
        summation[0] += caloriesPerPortion
        summation[1] += proteinsPerPortion
        summation[2] += carbsPerPortion
        summation[3] += sugarsPerPortion ?? 0
        summation[4] += fiberPerPortion ?? 0
        summation[5] += fatsPerPortion
        summation[6] += transPerPortion ?? 0
        
        return data
    }
}
