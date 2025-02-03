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
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    
    @Published var stocks: [Stock] = []
    @Published var error: NetworkError?
    @Published var lastFetchTime: String?

    init(repository: StockRepositoryProtocol?, pollingManager: StockPollingManagerProtocol?) {
        self.repository = repository
        self.pollingManager = pollingManager
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        // Set up polling
        self.pollingManager?.onStockDataUpdate = { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.error = nil
                    self?.lastFetchTime = formatter.string(from: Date.now)
                    self?.refreshStocks()
                    //not using server data because it doesnt has the track of favorite, loading data from db since the objects are stored in db
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
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
    func wishlistClicked(_ model: Stock) {
        DispatchQueue.main.async {
            self.showToast = true
            let stockName = StockType.allCases.filter({$0.stockCode == model.sid}).first?.stockName ?? ""
            self.toastMessage = model.isFav ?? false ? "\(stockName) \(Constants.wishlistAdded)" : "\(stockName) \(Constants.wishlistremoved)"
        }
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
