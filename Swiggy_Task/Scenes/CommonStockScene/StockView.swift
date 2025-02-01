//
//  StockView.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 01/02/25.
//

import SwiftUI
import SwiftData

struct StockView: View {
    @StateObject var viewModel: StockViewModel
    @State private var animateChange = false
    var onClickFav: ((Stock) -> ())?
    @Binding private var model: Stock
    init(model: Binding<Stock>, context: ModelContext, _ onClickFavorite: ((Stock) -> ())? = nil) {
        self.onClickFav = onClickFavorite
        self._model = model
        let networkManager = NetworkManager()
        let repository = StockRepository(network: networkManager, modelContext: context)
        _viewModel = StateObject(wrappedValue: StockViewModel(repository: repository))
    }
    var body: some View {
        ZStack(alignment: .topTrailing) {
            getTileView()
                .padding()
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5) // Green-tinted shadow
                )
                .padding(.horizontal)
            
            WishListButton(viewModel, $model, onClickFav: onClickFav)
                .padding(.top, -16)
                .padding(.trailing, 20)
            
        }
    }
    @ViewBuilder func getTileView() -> some View {
        HStack {
            Image(model.getImageName() ?? "REL")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .padding()
                .background(model.getBackgroundColor().opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(model.getItemName() ?? "")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("Ad eam errem homero doming, veniam delet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .center) {
                Text("\(model.price ?? 0, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.black)
                HStack(spacing: 16) {
                    Text("\(model.change ?? 0, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(model.change ?? 0 > 0 ? .green : .red)
                        .scaleEffect(animateChange ? 1.3 : 1.0) // Pop effect
                        .opacity(animateChange ? 1.0 : 0.5) // Flash effect
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: animateChange)
                    
                    Image(systemName: model.change ?? 0 > 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                        .foregroundColor(model.change ?? 0 > 0 ? .green : .red)
                        .frame(width: 20, height: 20)
                        .scaleEffect(animateChange ? 1.5 : 1.0) // Noticeable scaling effect
                        .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: animateChange)
                }
            }
        }
        .onAppear {
            animateChange = true  // Trigger animation on appear
        }
        .onChange(of: model.change) {
            animateChange = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateChange = true  // Restart animation when value changes
            }
        }
    }
}

#Preview {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StockEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    StockView(model: .constant(Stock(sid: "", price: 20, date: "", change: -30, high: 20, low: 20, volume: 200, isFav: true)), context: ModelContext(sharedModelContainer))
}
