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

            VStack {

                if let firstDate = transactions.first?.date {
                    DashboardChartView(selectedMonth: firstDate)
                }

                List {
                    ForEach(transactions) { item in
                        Section {
                            NavigationLink {
                                EditFinanceView(cashFlow: item)
                            } label: {
                                transactionRow(item)
                            }
                            .listRowBackground(Color.gray.opacity(0.5))
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deleteItems)
                }
                .listSectionSpacing(10)
                .scrollContentBackground(.hidden)
            }
        }
    }

    // MARK: - Row

    private func transactionRow(_ item: CashFlowModel) -> some View {
        HStack {
            Image(systemName: item.categoryIcon)
                .resizable()
                .frame(width: 45, height: 45)
                .padding(.trailing)

            VStack(alignment: .leading) {
                Text(item.categoryName)
                    .font(.title3)

                Text(item.type)
                    .font(.caption)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(item.amount, format: .currency(code: settings.currencyCode))
                    .font(.title3)

                Text(item.date, style: .date)
                    .font(.caption)
            }
        }
    }

    // MARK: - Delete

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            context.delete(transactions[index])
        }
        try? context.save()
    }
}

#Preview {
    // Create sample data for preview
    let sampleTransactions = [
        CashFlowModel(amount: 2.0, date: Date(), type: "", note: "", categoryName: "", categoryIcon: ""),
        CashFlowModel(amount: 2.0, date: Date(), type: "", note: "", categoryName: "", categoryIcon: "")
    ]
    
    MonthDetailView(transactions: sampleTransactions)
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(SettingsViewModel())
}

