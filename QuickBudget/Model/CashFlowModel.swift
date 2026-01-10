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
    var id = UUID()
    var amount: Double
    var date: Date
    var type: String
    var note: String
    var iconPicture: String
    var iconName: String
    
   // @Attribute(.ephemeral)
    var icon: String? = nil
    
    // new data for the frequency transactions
        var isRecurring: Bool = false
        var nextDate: Date? = nil
        var recurrenceFrequency: RecurrenceFrequency? = nil
        var recurrenceEndDate: Date? = nil
    
    @Relationship
    var category: CategoryModel
    
    
    init(id: UUID = UUID(), amount: Double, date: Date, type: String, iconPicture: String, note: String, iconName: String, category: CategoryModel) {
       
    
        self.amount = amount
        self.date = date
        self.type = type
        self.iconPicture = iconPicture
        self.note = note
        self.iconName = iconName
        self.category = category
        
    }
    
    enum RecurrenceFrequency: String, Codable {
        case daily
        case weekly
        case monthly
        case yearly
    }
    
   /* func groupByMonth(_ items: [CashFlowModel]) -> [String: [CashFlowModel]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy" // např. "Srpen 2025"
        
        return Dictionary(grouping: items) { item in
            formatter.string(from: item.date)
        }
    }*/


}

//chatgpt
/*
struct MonthYear: Hashable, Identifiable {
    let month: Int
    let year: Int

    var id: String { "\(month)-\(year)" }

    var title: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "cs_CZ")
        formatter.dateFormat = "LLLL yyyy"
        
        var comps = DateComponents()
        comps.month = month
        comps.year = year
        let date = Calendar.current.date(from: comps) ?? Date()
        
        return formatter.string(from: date).capitalized // např. "Leden 2025"
    }
    
    
}
*/
