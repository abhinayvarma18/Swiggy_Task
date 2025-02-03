//
//  StockListingView.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//

import SwiftUI
import SwiftData

struct StockListingView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var modelData: ModelData
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel: StockListingViewModel
    init(_ context: ModelContext) {
        let networkManager = NetworkManager()
        let repository = StockRepository(network: networkManager, modelContext: context)
        let pollingManager = StockPollingManager(repository: repository)
        
        _viewModel = StateObject(wrappedValue: StockListingViewModel(repository: repository, pollingManager: pollingManager))
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(alignment: .center, spacing: 4) {
                headerView()
                listView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toast(isShowing: $viewModel.showToast, message: viewModel.toastMessage)
            .onAppear {
                viewModel.refreshStocks()
                viewModel.pollingManager?.startPolling()
            }
            .onDisappear {
                viewModel.pollingManager?.stopPolling()
            }
            .navigationDestination(for: NavigationRouter.Screen.self, destination:  navigationDestination)
        }
        .onChange(of: scenePhase) { (phase, newPhase) in
            if newPhase == .background {
                viewModel.pollingManager?.stopPolling()
            } else if newPhase == .active {
                viewModel.pollingManager?.startPolling()
            }
        }
    }
    
    private func navigationDestination(screen: NavigationRouter.Screen) -> some View {
           switch screen {
           case .favorites:
               WishListView(modelContext: modelData.context)
           }
    }
    private func listView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack{
                ForEach($viewModel.stocks, id: \.sid) { $model in
                    StockView(model: $model, context: modelData.context) { model in
                        viewModel.wishlistClicked(model)
                    }
                    .padding(.bottom, 30)
                }
            }
            .padding(.vertical)
        }
        .padding(.vertical, 20)
        .background(LinearGradient(
            gradient: Gradient(colors: [Color.white, Color(hex: "#e4f8ed")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
        .frame(maxHeight: .infinity, alignment: .top)
        .border(.black.opacity(0.7))
    }
    
    private func headerView() -> some View {
        return VStack {
            Spacer()
            HStack {
                Text("Last synced at \(viewModel.lastFetchTime ?? "")")
                    .font(.headline)
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.center)
                Spacer()
                
                Button(action: {
                    router.navigate(to: .favorites)
                }) {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("Favorites")
                            .font(.headline)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .foregroundColor(.red)
                    .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .frame(height: 80.0)
        .background(Color(hex: "#F7881F"))
    }
    
    private func getErrorView() -> some View {
        VStack(alignment: .center, spacing: 40) {
            Spacer()
            Image("nointernet")
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
    StockListingView(ModelContext(sharedModelContainer))
        .environmentObject(ModelData())
        .environmentObject(NavigationRouter())
        .modelContainer(sharedModelContainer)
}
