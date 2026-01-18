//
//  AddFinanceView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 20.08.2025.
//

import SwiftData
import SwiftUI

struct AddFinanceView: View {

    @Query private var categories: [CategoryModel]

    let gradientColors: [Color] = [
        .gradientTop,
        .gradientBottom,
    ]
    @State private var selectedCategory: CategoryModel?
    @State var pickerSelectionType: String = ""
    @State var note: String = ""
    @State private var amount: Double = 0
    private var date = Date.now  //.formatted(.dateTime.day().month().year())
    //@State var pickerSelectionImage: String = "fork.knife.circle"
    @State private var selectedImage: String = ""
    @State private var selectedImageName: String = ""
    @FocusState private var amountIsFocused: Bool
    @State private var isShowingAlert = false
    @State private var errorMessage = ""
    @State private var contextMenuOn = false
    @State private var showBanner = false

    @State private var categorySheetOn: Bool = false

    //SwiftData
    @Query var cashFlow: [CashFlowModel]
    @Environment(\.modelContext) var context
    @EnvironmentObject var settings: SettingsViewModel
    // @EnvironmentObject var cashViewModel: CashFlowViewModel

    var colorAmountPicker: Color {
        switch pickerSelectionType {
        case "Expenses":
            Color.red.opacity(0.2)
        case "Savings":
            Color.yellow.opacity(0.2)
        case "Income":
            Color.green.opacity(0.2)
        default:
            Color.gray.opacity(0.1)
        }
    }

    var body: some View {

        ZStack {
            DataAddedBannerView(text: "Saved", isVisible: $showBanner)
            VStack {

                Text("Type")

                Picker(selection: $pickerSelectionType, label: Text("Picker")) {
                    Text("Expenses").tag("Expenses")
                    Text("Savings").tag("Savings")
                    Text("Income").tag("Income")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 300, height: 50)

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

                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorAmountPicker)
                )

                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .keyboardType(.decimalPad)
                .focused($amountIsFocused)
                .onTapGesture {
                    amount = 0
                }
                Text("Category")
                    .font(.headline)
                    .padding(.top)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 380, height: 90)
                        .foregroundColor(.gradientTop)

                    if categories.isEmpty {
                        VStack(alignment: .leading) {
                            Text("No category created")
                            NavigationLink(
                                "Go to settings",
                                destination: SettingsView()
                            )

                        }
                    } else {
                        CategoryIconView(
                            selectedImage: $selectedImage,
                            selectedImageName: $selectedImageName,
                            contextMenuOn: $contextMenuOn
                        ) { category in
                            selectedCategory = category
                            selectedImage = category.icon
                            selectedImageName = category.name
                            print("Category selected: \(category.name)")
                        }
                        .offset(x: 0, y: 6)
                    }
                }

                TextField("Note (optional)", text: $note)
                    .font(.title3)
                    .padding(.vertical, 10)
                    .padding(.horizontal)

                    .frame(width: 320)

                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)

                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)

                    )

                    .padding()
                    .focused($amountIsFocused)

                Button {
                    // 1. Zrušení focusu klávesnice
                    amountIsFocused = false

                    // 2. Validace
                    if amount == 0 {
                        errorMessage = "No amount has been entered"
                        isShowingAlert = true
                    } else if pickerSelectionType.isEmpty {
                        errorMessage =
                            "No type of transaction has been selected"
                        isShowingAlert = true
                    } else if let category = selectedCategory {
                        // Vše je v pořádku - Ukládáme
                        let newCashFlow = CashFlowModel(
                            amount: amount,
                            date: date,
                            type: pickerSelectionType,
                            iconPicture: category.icon,  // bereme přímo z kategorie
                            note: note,
                            iconName: category.name,  // bereme přímo z kategorie
                            category: category
                        )

                        context.insert(newCashFlow)

                        // Reset polí
                        resetForm()

                        withAnimation {
                            showBanner = true
                        }

                        // Skrytí banneru
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { showBanner = false }
                        }
                    } else {
                        // Pokud selectedCategory je nil

                        errorMessage = "No category has been selected"
                        isShowingAlert = true
                    }

                } label: {
                    Text("Save")
                        .font(.title)
                        .foregroundStyle(Color.blue)
                        .frame(width: 200, height: 50)
                        //.background(Color.cyan.opacity(0.3))
                        .background(Color.gradientTop)
                        .cornerRadius(12)
                }
                .padding()
                .alert("No data", isPresented: $isShowingAlert) {

                } message: {
                    Text(errorMessage)
                }
            }

        }
        .frame(width: 400, height: 800)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 50 {
                        amountIsFocused = false
                    }
                }
        )
        .onTapGesture {
            amountIsFocused = false
        }
    }

    private func resetForm() {
        selectedCategory = nil
        selectedImage = ""
        selectedImageName = ""
        amount = 0
        note = ""
        pickerSelectionType = ""
    }
}
#Preview {
    AddFinanceView()
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(SettingsViewModel())
}
