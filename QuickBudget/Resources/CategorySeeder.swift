//
//  CategorySeeder.swift
//  QuickBudget
//
//  Created by Richard Jambor on 12/20/25.
//

import Foundation
import SwiftData

enum CategorySeeder {

    static func seedIfNeeded(context: ModelContext) throws -> [CategoryModel] {

        let descriptor = FetchDescriptor<CategoryModel>()
        let existing = try context.fetch(descriptor)

        if !existing.isEmpty {
            return existing
        }

        let defaults = [
            CategoryModel(name: "Food", icon: "fork.knife"),
            CategoryModel(name: "Transport", icon: "car.fill"),
            CategoryModel(name: "Home", icon: "house.fill"),
            CategoryModel(name: "Fun", icon: "gamecontroller.fill"),
            CategoryModel(name: "Other", icon: "ellipsis.circle")
        ]

        defaults.forEach { context.insert($0) }
        try context.save()

        return defaults
    }
}
