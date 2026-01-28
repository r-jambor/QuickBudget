//
//  CashFlowModel.swift
//  QuickBudget
//
//  Created by Richard Jambor on 21.08.2025.
//

import Foundation
import SwiftData

@Model
class CashFlowModel: Identifiable {

    var id: UUID = UUID()
    var amount: Double
    var date: Date
    var type: String
    var note: String

    // Category snapshot
    var categoryName: String
    var categoryIcon: String
   // var categoryID: UUID?  // <-- tady místo PersistentIdentifier

    var isRecurring: Bool = false
    var nextDate: Date?
    var recurrenceFrequency: RecurrenceFrequency?
    var recurrenceEndDate: Date?

    init(
        amount: Double,
        date: Date,
        type: String,
        note: String,
      //  categoryID: UUID?,
        categoryName: String,
        categoryIcon: String
    ) {
        self.amount = amount
        self.date = date
        self.type = type
        self.note = note
        //self.categoryID = categoryID
        self.categoryName = categoryName
        self.categoryIcon = categoryIcon
    }

    enum RecurrenceFrequency: String, Codable {
        case daily, weekly, monthly, yearly
    }
}
