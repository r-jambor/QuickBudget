//
//  DashboardViewModel.swift
//  QuickBudget
//
//  Created by Richard Jambor on 09.11.2025.
//

import Foundation
class DashboardViewModel: ObservableObject {
    
   
// for showing the actual chart
    func items(for month: Date, from cashFlow: [CashFlowModel]) -> [CashFlowModel] {
        let calendar = Calendar.current
        
        return cashFlow.filter { item in
            calendar.isDate(item.date, equalTo: month, toGranularity: .month) &&
            calendar.isDate(item.date, equalTo: month, toGranularity: .year)
        }
    }
    
    // for counting in the middle of the dashboard
    func total(for type: String, in month: Date, from cashFlow: [CashFlowModel]) -> Double {
        let calendar = Calendar.current
        
        return cashFlow
            .filter { item in
                item.type == type &&
                calendar.isDate(item.date, equalTo: month, toGranularity: .month) &&
                calendar.isDate(item.date, equalTo: month, toGranularity: .year)
            }
            .map(\.amount)
            .reduce(0, +)
    }

}
