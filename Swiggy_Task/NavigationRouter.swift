//
//  NavigationRouter.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 01/02/25.
//

import SwiftUI

class NavigationRouter: ObservableObject {
    @Published var path: [Screen] = []
    
    enum Screen: Hashable {
        case favorites
    }
    
    func navigate(to screen: Screen) {
        path.append(screen)
    }
    
    func goBack() {
        path.removeLast()
    }
}
