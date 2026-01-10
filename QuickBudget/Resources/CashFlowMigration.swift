//
//  CashFlowMigration.swift
//  QuickBudget
//
//  Created by Richard Jambor on 12/20/25.
//

import Foundation
import SwiftData

enum CashFlowMigration {

    static func migrateIfNeeded(context: ModelContext) throws {

        let descriptor = FetchDescriptor<CashFlowModel>()
        let transactions = try context.fetch(descriptor)

        // už migrováno
        if transactions.allSatisfy({ $0.category != nil }) {
            return
        }

        let categories = try CategorySeeder.seedIfNeeded(context: context)

        let fallback =
            categories.first(where: { $0.name == "Other" }) ?? categories[0]

        for transaction in transactions where transaction.category == nil {
            transaction.category = fallback
        }

        try context.save()
    }
}
