//
//  AddCategoryView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 11/20/25.
//

import SwiftUI
import SwiftData

//
//  AddCategoryView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 11/20/25.
//

import SwiftUI
import SwiftData

struct AddCategoryView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let editingCategory: CategoryModel?

    @State private var name: String = ""
    @State private var selectedIcon: String = "folder"

    private let layout = [
        GridItem(.adaptive(minimum: 60))
    ]

    private let icons = IconRepository.icons

    init(editingCategory: CategoryModel? = nil) {
        self.editingCategory = editingCategory
    }

    var body: some View {
        VStack(spacing: 20) {

            Image(systemName: selectedIcon)
                .font(.system(size: 120))
                .frame(width: 200, height: 200)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(20)

            Text("Choose icon")

            ScrollView {
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(icons, id: \.self) { icon in
                        Image(systemName: icon)
                            .font(.title2)
                            .frame(width: 60, height: 60)
                            .background(
                                Circle()
                                    .fill(
                                        selectedIcon == icon
                                        ? Color.blue.opacity(0.25)
                                        : Color.gray.opacity(0.15)
                                    )
                            )
                            .overlay(
                                Circle()
                                    .stroke(
                                        selectedIcon == icon
                                        ? Color.blue
                                        : .clear,
                                        lineWidth: 2
                                    )
                            )
                            .onTapGesture {
                                selectedIcon = icon
                            }
                    }
                }
            }

            TextField("Category name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button {
                saveCategory()
            } label : {
                Text(editingCategory == nil ? "Add" : "Save")
                    .frame(width: 200, height: 50)
                    .background(Color.blue.opacity(0.25))
                    .cornerRadius(14)
                    .font(.title2)
            }
            

            Spacer()
        }
        .padding()
        .onAppear {
            if let category = editingCategory {
                name = category.name
                selectedIcon = category.icon
            }
        }
    }

    private func saveCategory() {

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            print("❌ Category name is empty")
            return
        }

        if let category = editingCategory {
            category.name = trimmedName
            category.icon = selectedIcon
        } else {
            let newCategory = CategoryModel(
                name: trimmedName,
                icon: selectedIcon
            )
            context.insert(newCategory)
        }

        do {
            try context.save()
            dismiss()
        } catch {
            print("❌ Failed to save category:", error)
        }
    }}

#Preview {
   
    AddCategoryView()
      
}

