//
//  StockRepository.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//


import SwiftData
import Foundation

protocol StockRepositoryProtocol {
    func fetchStockData(completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    func saveStocksToDatabase(_ stocks: [Stock])
    func loadCachedStocks() -> [Stock]
}

class StockRepository: StockRepositoryProtocol {
    private let network: Networking
    private let modelContext: ModelContext
    
    init(network: Networking, modelContext: ModelContext) {
        self.network = network
        self.modelContext = modelContext
    }
    
    // Fetch stock data from API
    func fetchStockData(completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        do {
            if let request = try network.createRequest(for: generateUrlForStocks()) {
                network.getData(request) { (result: Result<StockResponse, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            completion(.success(data.data ?? []))
                        case .failure:
                            completion(.failure(.networkError))
                        }
                    }
                }
            }
        } catch {
            completion(.failure(.invalidUrl))
        }
    }
    
    // Save stock data to SwiftData
    func saveStocksToDatabase(_ stocks: [Stock]) {
        do {
            let fetchDescriptor = FetchDescriptor<StockEntity>()
            let existingStocks = try modelContext.fetch(fetchDescriptor)
            for stock in existingStocks {
                modelContext.delete(stock)
            }
        } catch {
            print("Error deleting old stock data: \(error)")
        }
        
        for stock in stocks {
            let stockEntity = StockEntity(
                sid: stock.sid ?? "",
                price: stock.price ?? 0.0,
                date: stock.date ?? "",
                change: stock.change ?? 0.0,
                high: stock.high ?? 0.0,
                low: stock.low ?? 0.0,
                volume: stock.volume ?? 0.0
            )
            modelContext.insert(stockEntity)
        }
    }
    
    // Load cached stocks from SwiftData
    func loadCachedStocks() -> [Stock] {
        do {
            let fetchDescriptor = FetchDescriptor<StockEntity>()
            let storedStocks = try modelContext.fetch(fetchDescriptor)
            return storedStocks.map {
                Stock(
                    sid: $0.sid,
                    price: $0.price,
                    date: $0.date,
                    change: $0.change,
                    high: $0.high,
                    low: $0.low,
                    volume: $0.volume
                )
            }
        } catch {
            print("Error fetching cached stock data: \(error)")
            return []
        }
    }
    
    // Helper function to generate API URL
    private func generateUrlForStocks() -> String {
        let urlString = APIEndPoints.stockData
        return addQueryParams(urlString)
    }
    
    private func addQueryParams(_ url: String) -> String {
        var finalUrl = url + "?sids="
        for stock in StockType.allCases {
            finalUrl += stock.stockCode
            if stock != StockType.allCases.last {
                finalUrl += "%2C"
            }
        }
        return finalUrl
    }
}
