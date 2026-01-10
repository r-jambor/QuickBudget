//
//  HistoryView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 20.08.2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    
    @EnvironmentObject var settings: SettingsViewModel
    
    @Query var cashFlow: [CashFlowModel]
    @Environment(\.modelContext) private var context
    
    var grouped: [String: [CashFlowModel]] {
            groupByMonth(cashFlow)
        }
    var sample: [CashFlowModel] = [CashFlowModel(amount: 3000, date: .now, type: "Expenses", iconPicture: "", note: "", iconName: "", category: CategoryModel(name: "", icon: "")),
                                   CashFlowModel(amount: 30, date: .now, type: "Funds", iconPicture: "", note: "", iconName: "", category: CategoryModel(name: "", icon: "")),
                                   CashFlowModel(amount: 30, date: .now, type: "Savings", iconPicture: "", note: "", iconName: "", category: CategoryModel(name: "", icon: ""))]
    
    var groupedSample: [String: [CashFlowModel]] {
            groupByMonth(sample)
        }
    
    
    func totals(for month: String) -> (expenses: Double, savings: Double, funds: Double) {
        let items = grouped[month] ?? []
        
        let expenses = items
            .filter { $0.type == "Expenses" }
            .map { $0.amount }
            .reduce(0, +)
        
        let savings = items
            .filter { $0.type == "Savings" }
            .map { $0.amount }
            .reduce(0, +)
        
        let funds = items
            .filter { $0.type == "Funds" }
            .map { $0.amount }
            .reduce(0, +)
        
        return (expenses, savings, funds)
    }
    
    var body: some View {
     
        //CHATGPT
        List {
            ForEach(grouped.keys.sorted(), id: \.self) { month in
                let t = totals(for: month)
                
                Section {
                    
                    ZStack{
                        
                        
                        NavigationLink("",destination: MonthDetailView(transactions: grouped[month] ?? []))
                            .opacity(0)                    // schová odkaz
                            .buttonStyle(.plain)
                        
                            VStack(alignment: .leading){
                                HStack {
                                    
                                    Text(month)
                                        .font(.headline)
                                    Spacer()
                                    var balance = t.funds - t.expenses - t.savings
                                    var balanceColor: Color {
                                        if balance > 0 {
                                            return .green
                                        } else if balance < 0 {
                                            return .red
                                        } else {
                                            return .gray
                                        }
                                    }
                                    Text("\(balance, format: .currency(code: settings.currencyCode).precision(.fractionLength(0)))")
                                        .foregroundStyle(balanceColor)
                                        
                                        
                                }
                                Divider()
                                HStack(spacing: 16) {
                                    
                                    VStack(alignment: .leading) {
                                        HStack{
                                            Image(systemName: "arrow.down.forward.circle.fill")
                                                .foregroundStyle(.green)
                                            Text("Income")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                        }
                                        
                                        Text(t.funds, format: .currency(code: settings.currencyCode).precision(.fractionLength(0)))
                                            
                                            .font(.title3)
                                            .bold()
                                            .foregroundStyle(.green)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    }
                                    Divider()
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "arrow.up.forward.circle.fill")
                                                .foregroundStyle(.red)
                                            Text("Expenses")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                        }
                                        
                                        Text(t.expenses, format: .currency(code: settings.currencyCode).precision(.fractionLength(0)))
                                            .font(.title3)
                                            .bold()
                                            .foregroundStyle(.red)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    }
                                    Divider()
                                    VStack(alignment: .leading) {
                                        HStack{
                                            Image(systemName: "square.and.arrow.down.fill")
                                                .foregroundStyle(.orange)
                                            Text("Savings")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                        }
                                        
                                        Text(t.savings, format: .currency(code: settings.currencyCode).precision(.fractionLength(0)))
                                            .font(.title3)
                                            .bold()
                                            .foregroundStyle(.orange)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    }
                                    
                                    
                                }
                                .font(.subheadline)
                            }
                            .contentShape(Rectangle())
                        }
                        
                        .listRowSeparator(.hidden)
                    }
                .listRowBackground(Color.gray.opacity(0.32))
            }
                    .listSectionSpacing(10)
                }
        .scrollContentBackground(.hidden)
        
                        Spacer()
        
    }
}

#Preview {
    HistoryView()
}


func groupByMonth(_ items: [CashFlowModel]) -> [String: [CashFlowModel]] {
    let formatter = DateFormatter()
    formatter.dateFormat = "LLLL yyyy"
    return Dictionary(grouping: items) { item in
        formatter.string(from: item.date)
    }
}


