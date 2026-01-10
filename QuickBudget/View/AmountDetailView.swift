//
//  AmountDetailView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 26.08.2025.
//

import SwiftUI
import SwiftData

struct AmountDetailView: View {
    let gradientColors: [Color] = [
        .gradientTop,
        .gradientBottom
    ]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Bindable var cashFlow: CashFlowModel
    @State var contextMenuOn = false
    @State private var draft: CashFlowDraft
    @State private var showBannerDetail = false
    @FocusState private var keyboardFocus: Bool
    
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var cashViewModel: CashFlowViewModel
    
    init(cashFlow: CashFlowModel) {
        self._cashFlow = Bindable(wrappedValue: cashFlow)
        
        // Inicializace draftu z originálního modelu
        self._draft = State(initialValue:
            CashFlowDraft(
                type: cashFlow.type,
                amount: cashFlow.amount,
                note: cashFlow.note,
                iconName: cashFlow.iconName,
                iconPicture: cashFlow.iconPicture,
                date: cashFlow.date
            )
        )
    }
    
    var colorAmountPicker: Color {
        switch draft.type {
        case "Expenses":
            return Color.red.opacity(0.2)
        case "Savings":
            return Color.yellow.opacity(0.2)
        case "Funds":
            return Color.green.opacity(0.2)
        default:
            return Color.gray.opacity(0.1)
        }
    }
    
    var body: some View {
        ZStack {
            
            
            
            // Background
            LinearGradient(
                colors: [.gradientTop, .gradientBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                
                // TYPE
                Text("Type")
                Picker(selection: $draft.type, label: Text("Picker")) {
                    Text("Expenses").tag("Expenses")
                    Text("Savings").tag("Savings")
                    Text("Funds").tag("Funds")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 300, height: 50)
                
                // AMOUNT
                Text("Amount")
                
                TextField("Enter amount", value: $draft.amount, format: .currency(code: settings.currencyCode))
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
                    .focused($keyboardFocus)
                
                // CATEGORY
                Text("Category")
                    .font(.headline)
                
         /*       CategoryIconView(
                    selectedImage: $draft.iconPicture,
                    selectedImageName: $draft.iconName, contextMenuOn: $contextMenuOn
                )*/
                
                CategoryIconView(
                    selectedImage: $draft.iconPicture,
                    selectedImageName: $draft.iconName,
                    contextMenuOn: $contextMenuOn
                ) { category in

                    // PŘEDVYPLNĚNÍ UI
                    cashViewModel.selectedIcon = category.icon
                    cashViewModel.categoryName = category.name

                    // PŘEPNUTÍ DO EDIT REŽIMU
                //    editingCategoryID = category.id
               //     isEditing = true
                }
                
                // NOTE
                TextField("Note (optional)", text: $draft.note)
                    .font(.title3)
                    
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .frame(width: 320)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .padding()
                    
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
                
                // SAVE BUTTON
                Button {
                    saveChanges()
                } label: {
                    Text("Save")
                        .font(.title)
                        .foregroundStyle(Color.blue)
                        .frame(width: 200, height: 50)
                        .background(Color.gradientTop)
                        .cornerRadius(12)
                }
                
            }
            .padding()
            // Banner
            DataAddedBannerView(text: "Edited", isVisible: $showBannerDetail)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 50 {
                        keyboardFocus = false
                    }
                }
        )
        .onTapGesture {
            keyboardFocus = false
        }
    }
    
    
    // MARK: - SAVE FUNCTION
    private func saveChanges() {
        // Přepis hodnot z draftu do originálu
        cashFlow.type = draft.type
        cashFlow.amount = draft.amount
        cashFlow.note = draft.note
        cashFlow.iconName = draft.iconName
        cashFlow.iconPicture = draft.iconPicture
        cashFlow.date = draft.date
        
        try? context.save()
        
        withAnimation {
            showBannerDetail = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showBannerDetail = false
            }
        }
        
      //  dismiss()
    }
}

#Preview {
    AmountDetailView(cashFlow: CashFlowModel(amount: 3.0, date: .now, type: "Expenses", iconPicture: "", note: "", iconName: "", category: CategoryModel(name: "", icon: "")))
        .environmentObject(SettingsViewModel())
        .environmentObject(CashFlowViewModel())
}


struct CashFlowDraft {
    var type: String
    var amount: Double
    var note: String
    var iconName: String
    var iconPicture: String
    var date: Date
}
