//
//  SettingsView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 19.08.2025.
//

import SwiftUI
import SwiftData

struct SettingsView: View {

    let gradientColors: [Color] = [
        .gradientTop,
        .gradientBottom
    ]

    @Query(sort: \CategoryModel.name)
    private var categories: [CategoryModel]
    
    @EnvironmentObject var settings: SettingsViewModel

    @State private var selectedImage: String = ""
    @State private var selectedImageName: String = ""
    @State private var contextMenuOn = true
    @State var selectedCategory: CategoryModel?  
    @State private var sheetMode: CategorySheetMode?

    enum CategorySheetMode: Identifiable {
        case add
        case edit(CategoryModel)

        var id: String {
            switch self {
            case .add:
                return "add"
            case .edit(let category):
                return String(describing: category.id)
            }
        }
    }

    var body: some View {
        ZStack {

            LinearGradient(
                colors: gradientColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Form {

                // 🔔 NOTIFICATIONS
                Section {
                    Toggle(isOn: $settings.notificationsEnabled.animation()) {
                        Text("Daily notification")
                    }

                    if settings.notificationsEnabled {
                        DatePicker(
                            "Time",
                            selection: Binding(
                                get: { settings.notificationDate ?? Date() },
                                set: { settings.notificationDate = $0 }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .padding(.top)
                    }
                }
                .listRowBackground(Color.gray.opacity(0.32))

                // 💱 CURRENCY
                Picker("Currency", selection: $settings.currencyCode) {
                    ForEach(["CZK", "EUR", "USD"], id: \.self) {
                        Text($0)
                    }
                }
                .listRowBackground(Color.gray.opacity(0.32))
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden)

            // 👇 CATEGORY SECTION (mimo Form = žádné konflikty)
            VStack(alignment: .leading) {

                HStack {
                    Text("Category")
                        .font(.headline)

                    Spacer()

                    Button("Add category") {
                        sheetMode = .add
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 380, height: 90)
                        .foregroundColor(.gradientTop)
                    
                    CategoryIconView(
                        selectedImage: $selectedImage,
                        selectedImageName: $selectedImageName,
                        contextMenuOn: $contextMenuOn,
                        onSelect: { categoryID in
                            guard let categoryID else { return }

                            guard let category = categories.first(
                                where: { $0.persistentModelID == categoryID }
                            ) else {
                                return
                            }

                            sheetMode = .edit(category)
                        }
                    )
                    .offset(x: 0, y: 6)
                }
                
                .padding(.horizontal)
            }
            .padding(.top, 250) // doladíš dle layoutu
        }
        .sheet(item: $sheetMode) { mode in
            switch mode {
            case .add:
                AddCategoryView()

            case .edit(let category):
                AddCategoryView(editingCategory: category)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
        .modelContainer(for: CashFlowModel.self, inMemory: true)
       // .environmentObject(CashFlowViewModel())
}
