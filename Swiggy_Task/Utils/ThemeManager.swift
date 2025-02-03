//
//  ThemeManager.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 04/02/25.
//

import SwiftUI

protocol ThemeProtocol {
    var primaryColor: Color {get}
    var favSelectedIconColor: Color {get}
    var favUnSelectedIconColor: Color {get}
    var favShadowColor: Color {get}
    var stockListingGradient: LinearGradient {get}
    var wishlistGradient: LinearGradient {get}
    var gray: Color {get}
    var white: Color {get}
}

class ThemeManager: ObservableObject {
    @Published var selectedTheme: ThemeProtocol = MainTheme()
    
    func setTheme(_ theme: ThemeProtocol) {
        selectedTheme = theme
    }
}
