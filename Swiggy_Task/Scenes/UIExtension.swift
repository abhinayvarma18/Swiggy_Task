//
//  UIExtension.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 01/02/25.
//

import SwiftUI
extension Stock {
    func getImageName() -> String? {
        return StockType.allCases.first { $0.stockCode == self.sid }?.iconImageName
    }

    func getItemName() -> String? {
        return StockType.allCases.first { $0.stockCode == self.sid }?.stockName
    }

    func getBackgroundColor() -> Color {
        switch self.sid {
        case StockType.Reliance.stockCode:
            return Color(hex: "#3949a4")
        case StockType.ITC.stockCode:
            return Color(hex: "#ffdc3d")
        case StockType.HDFCBank.stockCode:
            return .purple
        case StockType.TCS.stockCode:
            return Color(hex: "#fe434c")
        case StockType.Infosys.stockCode:
            return Color(hex: "#b6e3c7")
        default:
            return Color(hex: "#3949a4")
        }
    }
}
