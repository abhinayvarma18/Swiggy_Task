//
//  Constants.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//
import SwiftUI
struct Constants {
    static let timeIntervalForPolling: Double = 5
    static let noStocksErrorString = "No Stocks Found"
    static let noStocksErrorStringSuggestion = "May be go back and try to wishlist few of the stocks"
    static let noDataImageName = "noData"
    static let errorImageName = "nointernet"
    static let errorTitle = "Oops we have encountered a problem"
    static let defaultErrorMessage = "Server error"
    static let wishlistAdded = "added to wishlist"
    static let wishlistremoved = "removed from wishlist"
    static let arrowUpImageName = "arrow.up.circle.fill"
    static let arrowDownImageName = "arrow.down.circle.fill"
    static let wishlistSelectedImage = "checkmark.circle.fill"
    static let wishlistunSelectedImage = "bookmark.fill"
    
    static let descriptionStock = "This stock is in top 5 trending NSE stocks"
}

enum APIEndPoints {
    static let stockData = "https://api.tickertape.in/stocks/quotes"
}
enum StockType: CaseIterable {
    case Reliance
    case ITC
    case TCS
    case HDFCBank
    case Infosys
    var stockCode: String {
        switch self {
        case .Reliance:
            "RELI"
        case .ITC:
            "ITC"
        case .TCS:
            "TCS"
        case .HDFCBank:
            "HDBK"
        case .Infosys:
            "INFY"
        }
    }
    var iconImageName: String {
        switch self {
        case .Reliance:
            return "REL"
        case .ITC:
            return "ITC"
        case .TCS:
            return "TCS"
        case .HDFCBank:
            return "HDFC"
        case .Infosys:
            return "INF"
        }
    }
    var stockName: String {
        switch self {
        case .Reliance:
            return "Reliance"
        case .ITC:
            return "ITC"
        case .TCS:
            return "TCS"
        case .HDFCBank:
            return "HDFC"
        case .Infosys:
            return "Infosys"
        }
    }
}
