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

    var sampleList: [CashFlowModel] = [
        CashFlowModel(
            amount: 30,
            date: Date(),
            type: "Expenses",
            iconPicture: "house.circle",
            note: "",
            iconName: "Test",
            category: CategoryModel(name: "", icon: "")
        ),
        CashFlowModel(
            amount: 30,
            date: Date(),
            type: "Expenses",
            iconPicture: "house.circle",
            note: "",
            iconName: "Test",
            category: CategoryModel(name: "", icon: "")
        ),
    ]

    var body: some View {

        let currentMonthItemsList = cashFlow.filter { item in
            Calendar.current.isDate(
                item.date,
                equalTo: Date(),
                toGranularity: .month
            )
        }

        VStack {
            List(currentMonthItemsList /*sampleList*/) { item in

                Section {
                    HStack {
             //old version without sync
                    //    Image(systemName: item.iconPicture)
             /*new version with sync*/
                        Image(systemName: item.category.icon)
                            .resizable()
                            .frame(width: 50, height: 50)
                            //  .background(Color.red)
                            .padding(.trailing)

                        VStack(alignment: .leading) {
                            //old version
                           // Text("\(item.iconName)")
                            Text(item.category.name)
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

                //   .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 15))
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
