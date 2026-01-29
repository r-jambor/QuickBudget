//
//  AmountDetailView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 26.08.2025.
//

import SwiftUI
import SwiftData

struct EditFinanceView: View {

    let gradientColors: [Color] = [.gradientTop, .gradientBottom]

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Bindable var cashFlow: CashFlowModel

    @State private var contextMenuOn = false
    @State private var showBannerDetail = false
    @FocusState private var keyboardFocus: Bool

    @EnvironmentObject var settings: SettingsViewModel

    // 🔹 DRAFT – jen SNAPSHOT data
    @State private var draft: CashFlowDraft

    init(cashFlow: CashFlowModel) {
        self._cashFlow = Bindable(wrappedValue: cashFlow)

        self._draft = State(
            initialValue: CashFlowDraft(
                type: cashFlow.type,
                amount: cashFlow.amount,
                note: cashFlow.note,
                categoryName: cashFlow.categoryName,
                categoryIcon: cashFlow.categoryIcon,
               // categoryID: cashFlow.categoryID,
                date: cashFlow.date
            )
        )
    }

    // MARK: - UI HELPERS

    var colorAmountPicker: Color {
        switch draft.type {
        case "Expenses": return .red.opacity(0.2)
        case "Savings": return .yellow.opacity(0.2)
        case "Income": return .green.opacity(0.2)
        default: return .gray.opacity(0.1)
        }
    }

    // MARK: - BODY

    var body: some View {
        ZStack {

            LinearGradient(
                colors: gradientColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {

                // TYPE
                Text("Type")
                Picker("Type", selection: $draft.type) {
                    Text("Expenses").tag("Expenses")
                    Text("Savings").tag("Savings")
                    Text("Income").tag("Income")
                }
                .pickerStyle(.segmented)
                .frame(width: 300)

                // AMOUNT
                Text("Amount")
                TextField(
                    "Enter amount",
                    value: $draft.amount,
                    format: .currency(code: settings.currencyCode)
                )
                .font(.largeTitle)
                .padding()
                .frame(width: 340)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorAmountPicker)
                )
                .focused($keyboardFocus)

                // CATEGORY
                Text("Category")
                    .font(.headline)

                CategoryIconView(
                    selectedImage: $draft.categoryIcon,
                    selectedImageName: $draft.categoryName,
                    contextMenuOn: $contextMenuOn, onEdit: { category in
                        print("Edit category tapped: \(category.name)")
                    },
                    
                )
                // NOTE
                TextField("Note (optional)", text: $draft.note)
                    .padding()
                    .frame(width: 320)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .focused($keyboardFocus)

                // DATE
                DatePicker("Date", selection: $draft.date, displayedComponents: .date)
                    .padding()

                // SAVE
                Button("Save") {
                    saveChanges()
                }
                .font(.title)
                .frame(width: 200, height: 50)
                .background(Color.gradientTop)
                .cornerRadius(12)
            }
            .padding()

            DataAddedBannerView(
                text: "Edited",
                isVisible: $showBannerDetail
            )
        }
        .onTapGesture { keyboardFocus = false }
    }

    // MARK: - SAVE

    private func saveChanges() {
        cashFlow.type = draft.type
        cashFlow.amount = draft.amount
        cashFlow.note = draft.note
        cashFlow.categoryName = draft.categoryName
        cashFlow.categoryIcon = draft.categoryIcon
        cashFlow.date = draft.date

        try? context.save()

        withAnimation { showBannerDetail = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showBannerDetail = false }
        }
    }
}

/*#Preview {
    EditFinanceView(cashFlow: CashFlowModel(amount: 3.0, date: .now, type: "Expenses", iconPicture: "", note: "", iconName: "", category: CategoryModel(name: "", icon: "")))
        .environmentObject(SettingsViewModel())
      //  .environmentObject(CashFlowViewModel())
}*/


struct CashFlowDraft {
    var type: String
    var amount: Double
    var note: String

    var categoryName: String
    var categoryIcon: String
    var categoryID: PersistentIdentifier?

    var date: Date
}
