//
//  TestView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 16.10.2025.
//
import SwiftData
import SwiftUI

struct TestView: View {
    
    let gradientColors: [Color] = [
        .gradientTop,
        .gradientBottom
    ]
    
    @Query var cashFlow: [CashFlowModel]
    @Environment(\.modelContext) private var context

    
    var body: some View {
                
        
            TabView {
                
                Tab("DashBoard", systemImage: "chart.pie") {
                    ZStack {
                        
                        VStack {
                            DashboardChartView(selectedMonth: Date())
                            Spacer()
                            Text("Overview for this month")
                            .padding(.top)
                            
                            RecentHistoryView()
                            .frame(width: .infinity, height: 250)
                        }
                        
                    }
                }
                Tab("Add", systemImage: "plus.circle") {
                    ZStack{
                        
                        AddFinanceView()
                    }
                
                
                }
                /*     Tab("Dashboard", systemImage: "chart.pie") {
                 
                 
                 
                 Spacer()
                 Text("Overview for this month")
                 .padding(.top)
                 
                 RecentHistoryView()
                 .frame(width: .infinity, height: 250)
                 
                 }
                 
                 Tab("Add", systemImage: "plus.circle") {
                 AddFinanceView()
                 
                 }
                 Tab("History", systemImage: "dollarsign.bank.building") {
                 HistoryView()
                 }*/
            }
        
        
    }
}

#Preview {
    TestView()
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(SettingsViewModel())
        .environmentObject(CashFlowViewModel())
}


