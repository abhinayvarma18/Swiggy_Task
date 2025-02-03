//
//  Constants.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//

struct Constants {
    static let timeIntervalForPolling: Double = 5
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
