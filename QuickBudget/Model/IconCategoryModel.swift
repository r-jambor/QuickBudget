//
//  IconModel.swift
//  QuickBudget
//
//  Created by Richard Jambor on 11/22/25.
//

import Foundation
struct IconCategoryModel: Identifiable, Codable {
    let id: UUID
    var icon: String
    var name: String

    init(id: UUID = UUID(), icon: String, name: String) {
        self.id = id
        self.icon = icon
        self.name = name
    }
}

