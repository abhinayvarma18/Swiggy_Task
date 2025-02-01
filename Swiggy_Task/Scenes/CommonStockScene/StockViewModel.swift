//
//  StocViewModel.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 01/02/25.
//
import SwiftUI
class StockViewModel: ObservableObject {
    private let repository: StockRepositoryProtocol?
    init(repository: StockRepositoryProtocol?) {
        self.repository = repository
    }
    func addRemoveWishList(_ model: Stock, _ isWishlist: Bool) {
        repository?.addRemoveToWishList(isWishlist, model)
    }
//    func checkIfStockInWishlist(_ model: Stock) -> Bool {
//        return repository?.checkIfStockInWishList(model) ?? false
//    }
}
