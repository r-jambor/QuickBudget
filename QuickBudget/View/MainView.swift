//
//  ContentView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 19.08.2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @State private var selectedTab: Int = 0
    let gradientColors: [Color] = [
        .gradientTop,
        .gradientBottom
    ]
    
    
    
    @Query var cashFlow: [CashFlowModel]
    @Environment(\.modelContext) private var context
    // @EnvironmentObject var settings: SettingsViewModel
    
    var body: some View {
        
        NavigationStack{
            TabView{
                
                Tab("Dashboard", systemImage: "chart.pie") {
                    ZStack{
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                        VStack{
                            DashboardChartView(selectedMonth: Date())
                            // Spacer()
                            Text("Overview for this month")
                                .padding(.top)
                            RecentHistoryView()
                                .frame(width: .infinity, height: 250)
                        }
                    }
                }
                
                
                Tab("Add", systemImage: "plus.circle") {
                    ZStack{
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                        AddFinanceView()
                    }
                }
                Tab("History", systemImage: "dollarsign.bank.building") {
                    ZStack{
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                        HistoryView()
                    }
                    
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            
        }
        
        
        
    }
    
}





#Preview {
    MainView()
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(SettingsViewModel())
        .environmentObject(CashFlowViewModel())
}
