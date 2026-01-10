//
//  AddFinanceView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 20.08.2025.
//

import SwiftUI
import SwiftData

struct AddFinanceView: View {
    
    let gradientColors: [Color] = [
        .gradientTop,
        .gradientBottom
    ]
    
    @State var pickerSelectionType: String = ""
    @State var note: String = ""
    @State private var amount: Double = 0
    private var date = Date.now//.formatted(.dateTime.day().month().year())
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
    @Environment(\.modelContext)  var context
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var cashViewModel: CashFlowViewModel
    
    
    var colorAmountPicker: Color {
        switch pickerSelectionType {
        case "Expenses":
            Color.red.opacity(0.2)
        case "Savings":
            Color.yellow.opacity(0.2)
        case "Funds":
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
                    Text("Funds").tag("Funds")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 300, height: 50)
                
                Text("Amount")
                
                TextField("Enter amount",
                          value: $amount,
                          format: .currency(code: settings.currencyCode))
                
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
                        .padding()
                    
                   
                    
                
                
                
                
                CategoryIconView(
                    selectedImage: $selectedImage,
                    selectedImageName: $selectedImageName,
                    contextMenuOn: $contextMenuOn
                ) { category in

                    // PŘEDVYPLNĚNÍ UI
                    cashViewModel.selectedIcon = category.icon
                    cashViewModel.categoryName = category.name

                    // PŘEPNUTÍ DO EDIT REŽIMU
            //        editingCategoryID = category.id
              //      isEditing = true
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
                    if amount == 0.0 {
                        isShowingAlert = true
                        errorMessage = "No amount has been entered"
                        
                    } else if selectedImage == ""{
                        isShowingAlert = true
                        errorMessage = "No category has been selected"
                        
                    } else if pickerSelectionType == "" {
                        isShowingAlert = true
                        errorMessage = "No type of transaction has been selected"
                        
                    } else {
                        let newCashFlow = CashFlowModel(amount: amount, date: date, type: pickerSelectionType, iconPicture: selectedImage, note: note, iconName: selectedImageName, category: CategoryModel(name: selectedImageName, icon: selectedImage))
                        context.insert(newCashFlow)
                        
                        selectedImage = ""
                        selectedImageName = ""
                        amount = 0
                        note = ""
                        amountIsFocused = false
                        pickerSelectionType = ""
                        
                        // pop up notification for succesfull data
                        withAnimation {
                            showBanner = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showBanner = false
                            }
                        }
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
    
}
#Preview {
    AddFinanceView()
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(SettingsViewModel())
        .environmentObject(CashFlowViewModel())
}
