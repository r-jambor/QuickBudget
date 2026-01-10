//
//  SettingsView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 19.08.2025.
//

import SwiftUI

struct SettingsView: View {
    
    let gradientColors: [Color] = [
        .gradientTop,
        .gradientBottom
    ]
    @EnvironmentObject var cashViewModel: CashFlowViewModel
  //  @State var categorySheetOn = false
    @State private var selectedImage: String = ""
    @State private var selectedImageName: String = ""
    @State private var contextMenuOn = true
    @EnvironmentObject var settings: SettingsViewModel
  //  @State private var isEditing = false
   // @State private var editingCategoryID: UUID?
    
    @State private var sheetMode: CategorySheetMode?
    
    enum CategorySheetMode: Identifiable {
        case add
        case edit(IconCategoryModel)

        var id: String {
            switch self {
            case .add:
                return "add"
            case .edit(let category):
                return category.id.uuidString
            }
        }
    }
    
    var body: some View {
        ZStack{
            
                
                
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                Form {
                    Section {
                        VStack{
                            Toggle(isOn: $settings.notificationsEnabled.animation()) {
                                Text("Daily notification")
                            }
                            if settings.notificationsEnabled {
                                DatePicker("Time", selection: Binding(
                                    get: { settings.notificationDate ?? Date() },
                                    set: { settings.notificationDate = $0 }
                                ),displayedComponents: .hourAndMinute)
                                .padding(.top)
                                
                            }
                        }
                    }
                    .listRowBackground(Color.gray.opacity(0.32))
                    
                    
                    Picker(selection: $settings.currencyCode, label: Text("Currency")) {
                        ForEach(["CZK", "EUR", "USD"], id: \.self) { currency in
                            Text(currency)
                        }
                    }
                    .pickerStyle(.automatic)
                    .listRowBackground(Color.gray.opacity(0.32))
                    
                    
                }
                .navigationTitle("Settings")
                .scrollDisabled(true)
                .scrollContentBackground(.hidden)
            
            VStack(alignment: .leading) {
                
                HStack{
                    Text("Category")
                        .font(.headline)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button("Add category") {
                        sheetMode = .add
                    }.padding(.horizontal)
                   /* .sheet(isPresented: $categorySheetOn, content: {
                        
                        AddCategoryView()
                        
                    })*/
                    
                }
                .padding(.bottom)
                

              //  CategoryIconView(selectedImage: $selectedImage, selectedImageName: $selectedImageName, contextMenuOn: $contextMenuOn)
                
                CategoryIconView(
                    selectedImage: $selectedImage,
                    selectedImageName: $selectedImageName,
                    contextMenuOn: $contextMenuOn
                ) { category in
                    sheetMode = .edit(category)
                }
                    .padding(.horizontal)
                
            }
            
            
        }
        .sheet(item: $sheetMode) { mode in
            switch mode {
            case .add:
                AddCategoryView()
                    .environmentObject(cashViewModel)

            case .edit(let category):
                AddCategoryView(
                    editingCategory: category
                )
                .environmentObject(cashViewModel)
            }
        }
    }
        
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
        .modelContainer(for: CashFlowModel.self, inMemory: true)
        .environmentObject(CashFlowViewModel())
}
