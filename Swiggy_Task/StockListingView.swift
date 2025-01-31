//
//  StockListingView.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//

import SwiftUI
import SwiftData

struct StockListingView: View {
    @StateObject private var viewModel: StockViewModel
    init(modelContext: ModelContext) {
        let networkManager = NetworkManager()
        let repository = StockRepository(network: networkManager, modelContext: modelContext)
        let pollingManager = StockPollingManager(repository: repository)
        
        _viewModel = StateObject(wrappedValue: StockViewModel(repository: repository, pollingManager: pollingManager))
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Stocks Watchlist")
                Spacer()
                Text("Last synced -: \(viewModel.lastFetchTime ?? "")")
            }
            .padding()
            ScrollView {
                VStack{
                    ForEach(viewModel.stocks, id: \.sid) { model in
                        StockView(viewModel: viewModel, model: model)
                            .padding(.bottom, 30)
                    }
                }
                .padding(.leading, 10)
                .padding(.top, 20)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(
            gradient: Gradient(colors: [Color.white, Color(hex: "#e4f8ed")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
    }
}

struct StockView: View {
    @ObservedObject var viewModel: StockViewModel
    let model: Stock
    var body: some View {
        ZStack {
            HStack {
                Image(viewModel.getImageName(model) ?? "REL")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .padding()
                    .background(viewModel.getBackgroundColor(model).opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.getItemName(model) ?? "")
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
                    Text("\(model.change ?? 0, specifier: "%.2f")%")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.green.opacity(0.2), radius: 10, x: 0, y: 5) // Green-tinted shadow
            )
            .padding(.horizontal)
            HStack{
                Spacer()
                VStack{
                    WishListButton()
                    Spacer()
                }
                .padding(.top, -20)
            }
            .padding(.trailing, 30)
        }
    }
}

struct WishListButton: View {
    @State private var isAdded = false
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                isAdded.toggle()
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }) {
            ZStack {
                Circle()
                    .fill(isAdded ? Color(hex: "#A0F0ED") : Color.white)
                    .frame(width: 40, height: 40)
                    .shadow(color: isAdded ? Color(hex: "#00B894").opacity(0.5) : Color.clear, radius: 5)
                
                Image(systemName: isAdded ? "checkmark.circle.fill" : "bookmark.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isAdded ? Color(hex: "#00B894") : .gray)
                    .scaleEffect(isAdded ? 1.2 : 1.0)
                    .rotationEffect(.degrees(isAdded ? 360 : 0))
                    .opacity(isAdded ? 1 : 0.8)
                    .animation(.easeInOut(duration: 0.3), value: isAdded)
            }
        }
        
    }
}

#Preview {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StockEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    StockListingView(modelContext: ModelContext(sharedModelContainer))
}
