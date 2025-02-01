//
//  WishListViewModel.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 01/02/25.
//


import SwiftUI

final class WishListViewModel: ObservableObject {
    private let repository: StockRepositoryProtocol?

    @Published var stocks: [Stock] = []

    init(repository: StockRepositoryProtocol?) {
        self.repository = repository
    }
    func loadData() {
        DispatchQueue.main.async {
            var models = self.repository?.loadWishList() ?? []
            models.sortByPriority()
            self.stocks =  models
        }
    }
    func removeFromWishList(_ model: Stock) {
        stocks.removeAll(where: {$0.sid == model.sid})
    }
}
