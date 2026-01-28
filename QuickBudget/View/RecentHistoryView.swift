//
//  RecentHistoryView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 19.08.2025.
//

import SwiftData
import SwiftUI

struct RecentHistoryView: View {

    @Query private var cashFlow: [CashFlowModel]
    @Environment(\.modelContext) private var context
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {

        let currentMonthItemsList = cashFlow.filter { item in
            Calendar.current.isDate(
                item.date,
                equalTo: Date(),
                toGranularity: .month
            )
        }

        VStack {
            List(currentMonthItemsList) { item in

                Section {
                    HStack {
                        Image(systemName: item.categoryIcon)
                            .resizable()
                            .frame(width: 50, height: 50)
                            //  .background(Color.red)
                            .padding(.trailing)

                        VStack(alignment: .leading) {
                            //old version
                           // Text("\(item.iconName)")
                            Text(item.categoryName)
                                .font(.title3)
                            Text("\(item.type)")
                                .font(.caption)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(
                                "\(item.amount, format: .currency(code: settings.currencyCode))"
                            )
                            .font(.title3)
                            Text("\(item.date, style: .date)")
                                .font(.caption)
                        }
                    }
                }
                .listRowBackground(Color.gray.opacity(0.32))
            }
            .scrollContentBackground(.hidden)
            .listSectionSpacing(10)
        }
    }
}

#Preview {
    RecentHistoryView()
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(SettingsViewModel())
}
