//
//  QuickBudgetApp.swift
//  QuickBudget
//
//  Created by Richard Jambor on 19.08.2025.
//

import SwiftUI
import SwiftData

/*@main
struct QuickBudgetApp: App {
    
    @StateObject private var settings = SettingsViewModel()
    @StateObject private var cashFlowViewModel = CashFlowViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: [CashFlowModel.self])
                .environmentObject(settings)
                .environmentObject(cashFlowViewModel)
                .preferredColorScheme(.dark)
        }
    }
}*/

//migrace
@main
struct QuickBudgetApp: App {

    @StateObject private var settings = SettingsViewModel()
    @StateObject private var cashFlowViewModel = CashFlowViewModel()

    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for:
                CashFlowModel.self,
                CategoryModel.self
            )

            let context = container.mainContext

            // 1️⃣ seed kategorií
            try CategorySeeder.seedIfNeeded(context: context)

            // 2️⃣ migrace transakcí
            try CashFlowMigration.migrateIfNeeded(context: context)

        } catch {
            fatalError("❌ SwiftData setup failed: \(error)")
        }
        print("🚀 SwiftData migrated successfully")
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.modelContext, container.mainContext)
                .environmentObject(settings)
                .environmentObject(cashFlowViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
