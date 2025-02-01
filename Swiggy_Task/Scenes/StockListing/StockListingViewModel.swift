//
//  Untitled.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//
import SwiftUI
import SwiftData

final class StockListingViewModel: ObservableObject {
    let repository: StockRepositoryProtocol?
    var pollingManager: StockPollingManagerProtocol?
    var timer: Timer?
    
    @Published var stocks: [Stock] = []
    @Published var error: NetworkError?
    @Published var lastFetchTime: String?

    init(repository: StockRepositoryProtocol?, pollingManager: StockPollingManagerProtocol?) {
        self.repository = repository
        self.pollingManager = pollingManager
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        // Set up polling
        self.pollingManager?.onStockDataUpdate = { [weak self] updatedStocks in
            DispatchQueue.main.async {
                self?.lastFetchTime = formatter.string(from: Date.now)
                self?.refreshStocks()
            }
        }
    }
    func refreshStocks() {
        DispatchQueue.main.async {
            var models = (self.repository?.loadCachedStocks() ?? [])
            models.sortByPriority()
            self.stocks = models
        }
    }
    deinit {
        pollingManager?.stopPolling()
    }
}


//MARK: test code to verify animation
//timer?.invalidate()
//timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//    guard let self = self, !self.stocks.isEmpty else { return }
//        
//    // Ensure we modify the struct properly
//    var newstocks = self.stocks
//    newstocks[0].change! += 10  //
//    DispatchQueue.main.async {
//        self.stocks = newstocks
//    }
//}
