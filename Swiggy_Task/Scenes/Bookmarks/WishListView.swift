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
                Spacer()
                Text("Wishlist")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            if !viewModel.stocks.isEmpty {
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
            } else {
                getNoDataView()
            }
            Spacer()
        }
        .background(LinearGradient(
            gradient: Gradient(colors: [Color.white, Color(hex: "#F7881F")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.loadData()
        }
    }
    @ViewBuilder func getNoDataView() -> some View {
        VStack(alignment: .center, spacing: 40) {
            Spacer()
            Image("noData")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 90)
            VStack(alignment: .center, spacing: 16) {
                Text("No Stocks Found")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black.opacity(0.7))
                Text("May be go back and try to wishlist few of the stocks")
                    .font(.title)
                    .bold()
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
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
