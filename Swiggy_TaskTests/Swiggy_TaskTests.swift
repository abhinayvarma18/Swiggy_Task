//
//  Swiggy_TaskTests.swift
//  Swiggy_TaskTests
//
//  Created by abhinay varma on 31/01/25.
//

import XCTest
import SwiftData
@testable import Swiggy_Task

class StockRepositoryTests: XCTestCase {
    var repository: StockRepository!
    var mockNetwork: MockNetworkManager!
    var modelContext: ModelContext!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager()
        let schema = Schema([StockEntity.self]) // Define schema for SwiftData
        let container = try! ModelContainer(for: schema, configurations: .init(isStoredInMemoryOnly: true)) // In-memory DB
        modelContext = ModelContext(container)
        repository = StockRepository(network: mockNetwork, modelContext: modelContext)
    }
    
    override func tearDown() {
        repository = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func testFetchStockData_Success() {
        guard let jsonURL = Bundle(for: type(of: self)).url(forResource: "stocks", withExtension: "json"),
              let jsonData = try? Data(contentsOf: jsonURL) else {
            XCTFail("Missing JSON file")
            return
        }
        
        mockNetwork.mockData = jsonData
        
        let expectation = self.expectation(description: "Fetching stock data")
        
        repository.fetchStockData { result in
            switch result {
            case .success(let stocks):
                XCTAssertEqual(stocks.count, 2, "Expected 2 stocks")
                XCTAssertEqual(stocks.first?.sid, "AAPL", "First stock should be AAPL")
                XCTAssertEqual(stocks.first?.price, 185.3, "AAPL price should be 185.3")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testFetchStockData_Failure() {
        mockNetwork.mockError = NetworkError.networkError
        
        let expectation = self.expectation(description: "Fetching stock data with failure")
        
        repository.fetchStockData { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.networkError, "Expected network error")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testSaveStocksToDatabase() {
        let stocks = [
            Stock(sid: "AAPL", price: 185.3, date: "2025-02-01", change: 2.1, high: 190.0, low: 180.0, volume: 1000000, isFav: false),
            Stock(sid: "GOOG", price: 2750.5, date: "2025-02-01", change: -5.2, high: 2800.0, low: 2700.0, volume: 2000000, isFav: false)
        ]
        
        repository.saveStocksToDatabase(stocks)
        
        let fetchDescriptor = FetchDescriptor<StockEntity>()
        let savedStocks = try? modelContext.fetch(fetchDescriptor)
        XCTAssertNotNil(savedStocks)
        XCTAssertEqual(savedStocks?.count, 2)
    }
    
    // ✅ Test loading cached stocks from SwiftData
    func testLoadCachedStocks() {
        let stockEntity = StockEntity(sid: "AAPL", price: 185.3, date: "2025-02-01", change: 2.1, high: 190.0, low: 180.0, volume: 1000000, isWishlist: false)
        modelContext.insert(stockEntity)
        
        let cachedStocks = repository.loadCachedStocks()
        
        XCTAssertEqual(cachedStocks.count, 1)
        XCTAssertEqual(cachedStocks.first?.sid, "AAPL")
        XCTAssertEqual(cachedStocks.first?.price, 185.3)
    }
    
    // ✅ Test adding stock to wishlist
    func testAddToWishlist() {
        let stock = Stock(sid: "AAPL", price: 185.3, date: "2025-02-01", change: 2.1, high: 190.0, low: 180.0, volume: 1000000, isFav: false)
        repository.saveStocksToDatabase([stock])
        
        repository.addRemoveToWishList(true, stock)
        
        let fetchDescriptor = FetchDescriptor<StockEntity>(predicate: #Predicate { $0.sid == "AAPL" })
        let wishlistStock = try? modelContext.fetch(fetchDescriptor).first
        
        XCTAssertNotNil(wishlistStock)
        XCTAssertTrue(wishlistStock?.isWishlist ?? false)
    }
    
    // Test removing stock from wishlist
    func testRemoveFromWishlist() {
        let stockEntity = StockEntity(sid: "AAPL", price: 185.3, date: "2025-02-01", change: 2.1, high: 190.0, low: 180.0, volume: 1000000, isWishlist: true)
        modelContext.insert(stockEntity)
        
        let stock = Stock(sid: "AAPL", price: 185.3, date: "2025-02-01", change: 2.1, high: 190.0, low: 180.0, volume: 1000000, isFav: true)
        repository.addRemoveToWishList(false, stock)
        
        let fetchDescriptor = FetchDescriptor<StockEntity>(predicate: #Predicate { $0.sid == "AAPL" })
        let updatedStock = try? modelContext.fetch(fetchDescriptor).first
        
        XCTAssertNotNil(updatedStock)
        XCTAssertFalse(updatedStock?.isWishlist ?? true)
    }
    
    // Test loading wishlist stocks
    func testLoadWishList() {
        let stockEntity = StockEntity(sid: "AAPL", price: 185.3, date: "2025-02-01", change: 2.1, high: 190.0, low: 180.0, volume: 1000000, isWishlist: true)
        modelContext.insert(stockEntity)
        
        let wishlist = repository.loadWishList()
        
        XCTAssertEqual(wishlist.count, 1)
        XCTAssertEqual(wishlist.first?.sid, "AAPL")
        XCTAssertTrue(wishlist.first?.isFav ?? false)
    }
}

class MockNetworkManager: Networking {
    var mockData: Data?
    var mockError: Error?
    
    func getData<T>(_ request: URLRequest, completion: ((Result<T, Error>) -> Void)?) where T : Decodable, T : Encodable {
        if let error = mockError {
            completion?(.failure(error))
        } else if let data = mockData {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion?(.success(decodedResponse))
            } catch {
                completion?(.failure(NetworkError.invalidData))
            }
        }
    }
    
    func createRequest(for url: String) throws -> URLRequest? {
        return URLRequest(url: URL(string: url)!)
    }
}
