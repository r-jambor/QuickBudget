//
//  CategoryModel.swift
//  QuickBudget
//
//  Created by Richard Jambor on 12/18/25.
//

 import Foundation
 import SwiftData

 @Model
 class CategoryModel {

     @Attribute(.unique)
     var id: UUID

     var name: String
     var icon: String

     init(name: String, icon: String) {
         self.id = UUID()
         self.name = name
         self.icon = icon
     }
 }
