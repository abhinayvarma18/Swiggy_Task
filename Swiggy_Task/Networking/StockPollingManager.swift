//
//  StockPollingManager.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//

import Foundation

protocol StockPollingManagerProtocol {
    var onStockDataUpdate: (([Stock]) -> Void)? { get set }
    func startPolling()
    func stopPolling()
}

class StockPollingManager: StockPollingManagerProtocol {
    private var timer: Timer?
    private let repository: StockRepositoryProtocol
    var onStockDataUpdate: (([Stock]) -> Void)?

    init(repository: StockRepositoryProtocol) {
        self.repository = repository
    }

    func startPolling() {
        timer?.invalidate()

        // Schedule a repeating timer to fetch stock data every 10 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.fetchStockData()
        }

        // Fetch initial data immediately
        fetchStockData()
    }

    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }

    private func fetchStockData() {
        repository.fetchStockData { [weak self] result in
            switch result {
            case .success(let stocks):
                self?.onStockDataUpdate?(stocks)
                self?.repository.saveStocksToDatabase(stocks)
            case .failure(let error):
                print("Stock API Error: \(error)")
            }
        }
    }

    deinit {
        stopPolling()
    }
}
