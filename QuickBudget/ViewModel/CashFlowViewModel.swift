//
//  CashFlowViewModel.swift
//  QuickBudget
//
//  Created by Richard Jambor on 18.11.2025.
//

import Foundation

/*class CashFlowViewModel: ObservableObject {
    // statická seznam ikon a kategorií
    var iconCategory: [(icon: String, name: String)] = [
        
    ]
    
    //variables selected by user
    @Published var selectedIcon: String = ""
    @Published var categoryName: String = ""
   // @Published var iconCategoryModel: [IconCategoryModel] = []
   
    
    
    func addCategory() {
           guard !selectedIcon.isEmpty,
                 !categoryName.isEmpty else { return }

        /*   let newCategory = IconCategoryModel(icon: selectedIcon, name: categoryName)
           iconCategoryModel.append(newCategory)*/
           
           saveIconCategories()

           // vyčištění vstupů
           selectedIcon = ""
           categoryName = ""
       }
    
    func updateCategory(id: UUID, name: String, icon: String) {
        guard let index = iconCategoryModel.firstIndex(where: { $0.id == id }) else { return }

        iconCategoryModel[index].name = name
        iconCategoryModel[index].icon = icon

        saveIconCategories()
    }
    
    func saveIconCategories() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(iconCategoryModel) {
            UserDefaults.standard.set(encoded, forKey: "iconCategories")
        }
    }
    
    func loadIconCategories() {
        if let savedData = UserDefaults.standard.data(forKey: "iconCategories") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([IconCategoryModel].self, from: savedData) {
                self.iconCategoryModel = decoded
            }
        }
    }
    
    func delete(item: IconCategoryModel) {
        iconCategoryModel.removeAll { $0.id == item.id }
        saveIconCategories()
    }
    
    init() {
        loadIconCategories()

        
        
    }
}
*/
