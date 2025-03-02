//
//  WishlistButton.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 01/02/25.
//

import SwiftUI

struct WishListButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: StockViewModel
    var onClickFav: ((Stock) -> ())?
    @Binding var model: Stock
    init(_ viewModel: StockViewModel, _ stock: Binding<Stock>, onClickFav: ((Stock) -> ())? = nil) {
        self.onClickFav = onClickFav
        self.viewModel = viewModel
        self._model = stock
    }
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                self.model.isFav?.toggle()
                viewModel.addRemoveWishList(model, self.model.isFav ?? false)
                onClickFav?(model)
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }) {
            ZStack {
                Circle()
                    .fill(self.model.isFav ?? false ? themeManager.selectedTheme.favSelectedIconColor : themeManager.selectedTheme.favUnSelectedIconColor.opacity(0.7))
                    .frame(width: 35, height: 35)
                    .shadow(color: self.model.isFav ?? false ? themeManager.selectedTheme.favShadowColor.opacity(0.5) : Color.clear, radius: 5)
                
                Image(systemName: self.model.isFav ?? false ? Constants.wishlistSelectedImage : Constants.wishlistunSelectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 21, height: 21)
                    .foregroundColor(self.model.isFav ?? false ? themeManager.selectedTheme.favShadowColor : themeManager.selectedTheme.white)
                    .scaleEffect(self.model.isFav ?? false ? 1.2 : 1.0)
                    .rotationEffect(.degrees(self.model.isFav ?? false ? 360 : 0))
                    .opacity(self.model.isFav ?? false ? 1 : 0.8)
                    .animation(.easeInOut(duration: 0.3), value: self.model.isFav ?? false)
            }
        }
    }
}
