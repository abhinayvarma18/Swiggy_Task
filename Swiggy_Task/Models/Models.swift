//
//  Models.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//
import SwiftData

struct StockResponse: Codable {
    let isSuccess: Bool?
    let data: [Stock]?
}
struct Stock: Codable {
    let sid: String?
    let price: Double?
    let date: String?
    let change: Double?
    let high: Double?
    let low: Double?
    let volume: Double?
    var isFav: Bool?
}

@Model
class StockEntity {
    @Attribute(.unique) var sid: String
    var price: Double
    var date: String
    var change: Double
    var high: Double
    var low: Double
    var volume: Double
    var isWishlist: Bool

    init(sid: String, price: Double, date: String, change: Double, high: Double, low: Double, volume: Double, isWishlist: Bool) {
        self.sid = sid
        self.price = price
        self.date = date
        self.change = change
        self.high = high
        self.low = low
        self.volume = volume
        self.isWishlist = isWishlist
    }
}
