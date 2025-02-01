//
//  WishListView.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 01/02/25.
//

import SwiftUI
import SwiftData

struct WishListView: View {
    @EnvironmentObject private var modelData: ModelData
    @StateObject private var viewModel: WishListViewModel
    init(modelContext: ModelContext) {
        let networkManager = NetworkManager()
        let repository = StockRepository(network: networkManager, modelContext: modelContext)
        _viewModel = StateObject(wrappedValue: WishListViewModel(repository: repository))
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Stocks Wishlist")
                Spacer()
            }
            .padding()
            ScrollView {
                VStack{
                    ForEach($viewModel.stocks, id: \.sid) { $model in
                        StockView(model: $model, context: modelData.context) { (newmodel) in
                            viewModel.removeFromWishList(newmodel)
                        }
                        .padding(.bottom, 30)
                    }
                }
                .padding(.leading, 10)
                .padding(.top, 20)
            }
            Spacer()
        }
        .background(LinearGradient(
            gradient: Gradient(colors: [Color.white, Color(hex: "#F7881F")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.loadData()
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
    WishListView(modelContext: ModelContext(sharedModelContainer))
}
