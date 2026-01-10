//
//  AddCategoryView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 11/20/25.
//

import SwiftUI
import SwiftData

struct AddCategoryView: View {
    
    @EnvironmentObject var cashViewModel: CashFlowViewModel
    @State var selectedImage: String = ""
    @State var selectedImageName: String = ""
    @State var contextMenuOn = false
    @State var selectedIcon: String = ""
    @State private var isEditing = false
    @State private var editingCategoryID: UUID?
    
    let editingCategory: IconCategoryModel?
    init(editingCategory: IconCategoryModel? = nil) {
        self.editingCategory = editingCategory
    }
        let layout = [
            GridItem(.adaptive(minimum: 60))
        ]
    private let icons = IconRepository.icons
    @Query var categories: [CategoryModel]
    @Environment(\.modelContext) var context
    @State private var name = ""
    //@State private var selectedIcon = ""
   // let editingCategory: CategoryModel?
    
    var body: some View {
        VStack{
            Text("Selected icon")
                .padding()
            Image(systemName: cashViewModel.selectedIcon)
            
                .frame(width: 250, height: 180)
                
                .background(Color.gray)
                .font(.system(size: 150))
                .padding()
            
            Text("Choose your icon")
                .padding(.top)
            ScrollView {
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(icons, id: \.self) { icon in
                        Image(systemName: icon)
                            .font(.title)
                            .frame(width: 60, height: 60)
                            .background(
                                Circle()
                                    .fill(cashViewModel.selectedIcon == icon ? Color.blue.opacity(0.2): Color.gray.opacity(0.1))
                            )
                            .overlay(
                                Circle().stroke(cashViewModel.selectedIcon == icon ? Color.blue : .clear, lineWidth: 2)
                                                    )
                            .onTapGesture {
                                cashViewModel.selectedIcon = icon
                            }
                    }
                }
                .padding()
            }
            
            
            
            
            
            TextField("Name", text: $cashViewModel.categoryName)
                .font(.title3)
                .frame(width: 320)
                
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                      
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        
                )
                
                .padding()
                
          /*  Button(editingCategory == nil ? "Add" : "Save") {

                if let category = editingCategory {
                    cashViewModel.updateCategory(
                        id: category.id,
                        name: cashViewModel.categoryName,
                        icon: cashViewModel.selectedIcon
                    )
                } else {
                    cashViewModel.addCategory()
                }
            }*/
            Button(editingCategory == nil ? "Add" : "Save") {

                if var category = editingCategory {
                    category.name = name
                    category.icon = selectedIcon
                } else {
                    let newCategory = CategoryModel(
                        name: name,
                        icon: selectedIcon
                    )
                    context.insert(newCategory)
                }

                try? context.save()
            }
            .font(.title)
            .foregroundStyle(Color.blue)
            .frame(width: 200, height: 50)
            .background(Color.cyan.opacity(0.3))
            .cornerRadius(12)
        }
        /*.onAppear {
            if let category = editingCategory {
                cashViewModel.selectedIcon = category.icon
                cashViewModel.categoryName = category.name
            }*/
        .onAppear {
            if let category = editingCategory {
                name = category.name
                selectedIcon = category.icon
            }
        
        }
    }
    
}

#Preview {
   // @State var selectedIcon: String = ""
    AddCategoryView()
        .environmentObject(CashFlowViewModel())
}
