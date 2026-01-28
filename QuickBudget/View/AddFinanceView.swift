//
//  AddFinanceView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 20.08.2025.
//

import SwiftData
import SwiftUI

struct AddFinanceView: View {

    // MARK: - Queries
    @Query private var categories: [CategoryModel]
    @Query private var cashFlow: [CashFlowModel]

    // MARK: - Environment
    @Environment(\.modelContext) private var context
    @EnvironmentObject var settings: SettingsViewModel
    @FocusState private var amountIsFocused: Bool

    // MARK: - UI States
    let gradientColors: [Color] = [.gradientTop, .gradientBottom]

    @State private var pickerSelectionType: String = ""
    @State private var note: String = ""
    @State private var amount: Double = 0
    private var date = Date.now
    @State private var selectedImage: String = ""
    @State private var selectedImageName: String = ""
    @State private var contextMenuOn = false
    @State private var showBanner = false
    @State private var isShowingAlert = false
    @State private var errorMessage = ""

    // MARK: - Selected Category (PersistentIdentifier)
    @State private var selectedCategoryID: PersistentIdentifier?

    // MARK: - Helpers
    var colorAmountPicker: Color {
        switch pickerSelectionType {
        case "Expenses": return Color.red.opacity(0.2)
        case "Savings": return Color.yellow.opacity(0.2)
        case "Income": return Color.green.opacity(0.2)
        default: return Color.gray.opacity(0.1)
        }
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            DataAddedBannerView(text: "Saved", isVisible: $showBanner)

            VStack(spacing: 20) {

                // TYPE
                Text("Type")
                Picker(selection: $pickerSelectionType, label: Text("Picker")) {
                    Text("Expenses").tag("Expenses")
                    Text("Savings").tag("Savings")
                    Text("Income").tag("Income")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 300, height: 50)

                // AMOUNT
                Text("Amount")
                TextField(
                    "Enter amount",
                    value: $amount,
                    format: .currency(code: settings.currencyCode)
                )
                .font(.largeTitle)
                .padding(.vertical, 28)
                .padding(.horizontal)
                .frame(width: 340)
                .background(RoundedRectangle(cornerRadius: 10).fill(colorAmountPicker))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4), lineWidth: 1))
                .keyboardType(.decimalPad)
                .focused($amountIsFocused)
                .onTapGesture { amount = 0 }

                // CATEGORY
                Text("Category").font(.headline)
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 380, height: 90)
                        .foregroundColor(.gradientTop)

                    if categories.isEmpty {
                        VStack(alignment: .leading) {
                            Text("No category created")
                            NavigationLink("Go to settings", destination: SettingsView())
                        }
                    } else {
                        CategoryIconView(
                            selectedImage: $selectedImage,
                            selectedImageName: $selectedImageName,
                            contextMenuOn: $contextMenuOn,
                            onSelect: { categoryID in
                                selectedCategoryID = categoryID
                            }
                        )
                        .offset(x: 0, y: 6)
                    }
                }

                // NOTE
                TextField("Note (optional)", text: $note)
                    .font(.title3)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .frame(width: 320)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4), lineWidth: 1))
                    .focused($amountIsFocused)

                // SAVE BUTTON
                Button {
                    saveTransaction()
                } label: {
                    Text("Save")
                        .font(.title)
                        .foregroundStyle(Color.blue)
                        .frame(width: 200, height: 50)
                        .background(Color.gradientTop)
                        .cornerRadius(12)
                }
                .padding()
                .alert("No data", isPresented: $isShowingAlert) {
                } message: {
                    Text(errorMessage)
                }
            }
            .padding()
        }
        .frame(width: 400, height: 800)
        .contentShape(Rectangle())
        .gesture(DragGesture().onEnded { value in
            if value.translation.height > 50 { amountIsFocused = false }
        })
        .onTapGesture { amountIsFocused = false }
    }

    // MARK: - Save Function
    private func saveTransaction() {
        amountIsFocused = false

        // VALIDACE
        guard amount != 0 else {
            errorMessage = "No amount has been entered"
            isShowingAlert = true
            return
        }

        guard !pickerSelectionType.isEmpty else {
            errorMessage = "No type of transaction has been selected"
            isShowingAlert = true
            return
        }

      /*  guard let categoryUUIDString = selectedCategoryID?.description,
              let categoryUUID = UUID(uuidString: categoryUUIDString),
              !selectedImageName.isEmpty else {
            errorMessage = "No category has been selected"
            isShowingAlert = true
            return
        }*/

        // Vytvoření CashFlowModel
        let newCashFlow = CashFlowModel(
            amount: amount,
            date: date,
            type: pickerSelectionType,
            note: note,
           // categoryID: categoryUUID,
            categoryName: selectedImageName,
            categoryIcon: selectedImage
        )
        context.insert(newCashFlow)

        resetForm()

        withAnimation { showBanner = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showBanner = false }
        }
    }

    // MARK: - Reset Form
    private func resetForm() {
        selectedCategoryID = nil
        selectedImage = ""
        selectedImageName = ""
        amount = 0
        note = ""
        pickerSelectionType = ""
    }
}

// MARK: - Preview
#Preview {
    AddFinanceView()
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(SettingsViewModel())
}
#Preview {
    AddFinanceView()
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(SettingsViewModel())
}

