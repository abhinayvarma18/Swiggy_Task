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

struct MainTheme: ThemeProtocol {
    var primaryColor = Color(hex: "#F7881F")
    var favSelectedIconColor = Color(hex: "#A0F0ED")
    var favUnSelectedIconColor = Color.orange
    var favShadowColor = Color(hex: "#00B894")
    var stockListingGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white, Color(hex: "#e4f8ed")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    var wishlistGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white, Color(hex: "#F7881F")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    var gray = Color.gray
    var white = Color.white
}
