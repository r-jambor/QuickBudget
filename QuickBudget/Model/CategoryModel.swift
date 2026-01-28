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
    var name: String
    var icon: String
    var colorHex: String?

    init(name: String, icon: String, colorHex: String? = nil) {
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
    }
}
