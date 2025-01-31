//
//  Untitled.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//
import SwiftUI

final class StockViewModel: ObservableObject {
    private let repository: StockRepositoryProtocol?
    private var pollingManager: StockPollingManagerProtocol?

    @Published var stocks: [Stock] = []
    @Published var error: NetworkError?
    @Published var lastFetchTime: String?

    init(repository: StockRepositoryProtocol?, pollingManager: StockPollingManagerProtocol?) {
        self.repository = repository
        self.pollingManager = pollingManager

        // Load cached stocks initially
        self.stocks = repository?.loadCachedStocks() ?? []
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        // Set up polling
        self.pollingManager?.onStockDataUpdate = { [weak self] updatedStocks in
            DispatchQueue.main.async {
                self?.lastFetchTime = formatter.string(from: Date.now)
                self?.stocks = updatedStocks
            }
        }
        pollingManager?.startPolling()
    }
    func getImageName(_ model: Stock) -> String? {
        return StockType.allCases.filter{$0.stockCode == model.sid}.first?.iconImageName
    }
    func getItemName(_ model: Stock) -> String? {
        return StockType.allCases.filter{$0.stockCode == model.sid}.first?.stockName
    }
    func getBackgroundColor(_ model: Stock) -> Color {
        switch model.sid {
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
    deinit {
        pollingManager?.stopPolling()
    }
}
