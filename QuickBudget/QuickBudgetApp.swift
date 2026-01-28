//
//  QuickBudgetApp.swift
//  QuickBudget
//
//  Created by Richard Jambor on 19.08.2025.
//

import SwiftUI
import SwiftData

@main
struct QuickBudgetApp: App {
    
    @StateObject private var settings = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: [CashFlowModel.self, CategoryModel.self])
                .environmentObject(settings)
                .preferredColorScheme(.dark)
        }
    }
}
