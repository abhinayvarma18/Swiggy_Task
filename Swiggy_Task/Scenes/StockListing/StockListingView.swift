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
                VStack {
                    Spacer()
                    HStack {
                        Text("Last synced at \(viewModel.lastFetchTime ?? "")")
                            .font(.headline)
                            .foregroundColor(.black)
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
                                    .foregroundColor(.red)
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
                .background(Color.orange.opacity(0.7))
                ScrollView(showsIndicators: false) {
                    VStack{
                        ForEach($viewModel.stocks, id: \.sid) { $model in
                            StockView(model: $model, context: modelData.context)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewModel.refreshStocks()
                viewModel.pollingManager?.startPolling()
            }
            .onDisappear {
                viewModel.pollingManager?.stopPolling()
            }
            .navigationDestination(for: NavigationRouter.Screen.self) { screen in
                switch screen {
                case .favorites:
                    WishListView(modelContext: modelData.context)
                }
            }
        }
        .onChange(of: scenePhase) { (phase, newPhase) in
            if newPhase == .background {
                viewModel.pollingManager?.stopPolling()
            } else if newPhase == .active {
                viewModel.pollingManager?.startPolling()
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
    StockListingView(ModelContext(sharedModelContainer))
        .environmentObject(ModelData())
        .environmentObject(NavigationRouter())
        .modelContainer(sharedModelContainer)
}
