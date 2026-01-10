//
//  MonthDetailView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 26.08.2025.
//

import SwiftUI
import SwiftData

struct MonthDetailView: View {
    

    @Environment(\.modelContext) private var context
    let transactions: [CashFlowModel]
    @EnvironmentObject var settings: SettingsViewModel
    
    //filter for the expenses
    var expensesTransactions: [CashFlowModel] {
        transactions.filter { $0.type == "Expenses" }
    }
    
    //filter for the savings
    var savingsTransactions: [CashFlowModel] {
        transactions.filter { $0.type == "Savings" }
    }
    
    //filter for the income
    var incomeeTransactions: [CashFlowModel] {
        transactions.filter { $0.type == "Income" }
    }
    
    
    let gradientColors: [Color] = [
        .gradientTop,
        .gradientBottom
    ]
    
    var body: some View {
        
        
        
        ZStack {
            LinearGradient(
                colors: gradientColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack{
                
                if let firstDate = transactions.first?.date {
                    DashboardChartView(selectedMonth: firstDate)
                }
                
                /*   //lines for showing all the expenses etc.
                 Text("Expanses: \(expensesTransactions.map(\.amount).reduce(0, +), format: .currency(code: settings.currencyCode))")
                 
                 
                 Text("Savings: \(savingsTransactions.map(\.amount).reduce(0, +), format: .currency(code: settings.currencyCode))")
                 
                 
                 Text("Income: \(IncomeTransactions.map(\.amount).reduce(0, +), format: .currency(code: settings.currencyCode))")*/
                
                
                
                
                List {
                    
                    ForEach(transactions) { item in
                        Section{
                        NavigationLink(destination: EditFinanceView(cashFlow: item)) {
                            
                                HStack{
                                   // Image(systemName: item.iconPicture)
                                    Image(systemName: item.category.icon)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    //  .background(Color.red)
                                        .padding(.trailing)
                                    
                                    VStack(alignment: .leading){
                                       // Text("\(item.iconName)")
                                        Text("\(item.category.name)")
                                            .font(.title3)
                                        Text("\(item.type)")
                                            .font(.caption)
                                    }
                                    
                                    
                                    Spacer()
                                    VStack(alignment: .trailing){
                                        Text("\(item.amount, format: .currency(code: settings.currencyCode))")
                                            .font(.title3)
                                        Text("\(item.date, style: .date)")
                                            .font(.caption)
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                            .listRowBackground(Color.gray.opacity(0.5))
                            
                        }
                        
                        .listRowSeparator(.hidden)
                    }
                    
                    .onDelete(perform: deleteItems)
                    //   .scrollContentBackground(.hidden)
                    .listSectionSpacing(10)
                    .listRowSeparator(.hidden)
                }
                
                .scrollContentBackground(.hidden)
                
            }
        }
        /* List {
         
         ForEach(transactions) { item in
             NavigationLink(destination: AmountDetailView(cashFlow: item)) {
                 HStack {
                     Text("\(Image(systemName: item.iconPicture))")
                     Spacer()
                     Text(item.type)
                     Spacer()
                     Text(item.amount, format: .currency(code: settings.currencyCode))
                 }
             }
         }
         .onDelete(perform: deleteItems)
     }*/
                
            
        
      //  .navigationTitle("Transactions")
    }
        
    
// Nová metoda pro smazání položek
    private func deleteItems(offsets: IndexSet) {
     for index in offsets {
         let itemToDelete = transactions[index]
            context.delete(itemToDelete)
        }
    }
}

#Preview {
    // Create sample data for preview
    let sampleTransactions = [
        CashFlowModel(amount: 2.0, date: .now, type: "Expenses", iconPicture: "house.circle", note: "test", iconName: "Living", category: CategoryModel(name: "", icon: "")),
        CashFlowModel(amount: 2.0, date: .now, type: "Expenses", iconPicture: "house.circle", note: "test", iconName: "Living", category: CategoryModel(name: "", icon: ""))
    ]
    
    MonthDetailView(transactions: sampleTransactions)
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(SettingsViewModel())
}
