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
    
    @State private var selectedCategoryID: PersistentIdentifier?
    
    @State private var contextMenuOn = false
    @State private var showBannerDetail = false
    @FocusState private var keyboardFocus: Bool

    @EnvironmentObject var settings: SettingsViewModel

    // 🔹 DRAFT – jen SNAPSHOT data
    @State private var draft: CashFlowDraft

    init(cashFlow: CashFlowModel) {
        self._cashFlow = Bindable(wrappedValue: cashFlow)

        // Pokud chceš jen, aby se správně vybral item v CategoryIconView, použij nil nebo find podle názvu/ikony
        self._selectedCategoryID = State(initialValue: nil)
        
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
                .padding(.bottom)
                // AMOUNT
                Text("Amount")
                TextField(
                    "Enter amount",
                    value: $draft.amount,
                    format: .currency(code: settings.currencyCode)
                )
                .font(.largeTitle)
                .padding(.vertical, 28)
                .padding(.horizontal)
                .frame(width: 340)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorAmountPicker)
                )
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4), lineWidth: 1))
                .keyboardType(.decimalPad)
                .focused($keyboardFocus)

                // CATEGORY
                Text("Category")
                    .font(.headline)
                    .padding(.top)
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 380, height: 115)
                        .foregroundColor(.gradientTop)
                    CategoryIconView(
                        selectedCategoryID: $selectedCategoryID,
                        selectedImage: $draft.categoryIcon,
                        selectedImageName: $draft.categoryName,
                        contextMenuOn: $contextMenuOn, onEdit: { category in
                            print("Edit category tapped: \(category.name)")
                        },
                        
                    )
                }
                .padding(.bottom)
                // NOTE
                Text("Note")
                TextField("Note (optional)", text: $draft.note)
                    
                    .padding()
                    .frame(width: 320)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4), lineWidth: 1))
                    .cornerRadius(10)
                    .focused($keyboardFocus)
             

                // DATE
                Form {
                                    Section {
                                        DatePicker("Date", selection: $draft.date, displayedComponents: .date)
                                    }
                                    .listRowBackground(Color.gray.opacity(0.1))
                                }
                .scrollContentBackground(.hidden)
                                .frame(width: 420, height: 100)
                                .scrollDisabled(true)
                                .padding(.bottom)
                                .padding(.bottom)

                // SAVE
                Button {
                    saveChanges()
                } label : {
                    Text("Save")
                        .frame(width: 200, height: 50)
                        .background(Color.gradientTop)
                        .cornerRadius(14)
                        .font(.title)
                }
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
       // cashFlow.categoryID = selectedCategoryID
        try? context.save()

        withAnimation { showBannerDetail = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showBannerDetail = false }
        }
    }
}

#Preview {
    EditFinanceView(cashFlow: CashFlowModel(amount: 2.0, date: Date(), type: "Income", note: "test", categoryName: "question", categoryIcon: "test"))
        .environmentObject(SettingsViewModel())
      //  .environmentObject(CashFlowViewModel())
}


struct CashFlowDraft {
    var type: String
    var amount: Double
    var note: String

    var categoryName: String
    var categoryIcon: String
    var categoryID: PersistentIdentifier?

    var date: Date
}

