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
