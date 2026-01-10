//
//  SettingsViewModel.swift
//  QuickBudget
//
//  Created by Richard Jambor on 28.10.2025.
//

import Foundation
import SwiftUI
import UserNotifications

@MainActor
class SettingsViewModel: ObservableObject {
    
    
    
    @Published var currencyCode: String {
        didSet { UserDefaults.standard.set(currencyCode, forKey: "currencyCode") }
    }
    
    @Published var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
            handleNotificationToggle()
        }
    }
    
    @Published var notificationDate: Date? {
        didSet { UserDefaults.standard.set(notificationDate, forKey: "notificationDate")
            handleNotificationTimeChange()
        }
    }
    
    
    init() {
        self.currencyCode = UserDefaults.standard.string(forKey: "currencyCode") ?? "CZK"
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        self.notificationDate = UserDefaults.standard.object(forKey: "notificationDate") as? Date
        
        // požádáme o oprávnění při startu
        NotificationManager.shared.requestAuthorization()
        
        // pokud je uživatel měl zapnuté, po restartu appky je znovu aktivujeme
        if notificationsEnabled, let date = notificationDate {
            NotificationManager.shared.scheduleDailyNotification(at: date)
        }
    }
    // MARK: - Notification Handling
    
    private func handleNotificationToggle() {
        if notificationsEnabled {
            if let date = notificationDate {
                NotificationManager.shared.scheduleDailyNotification(at: date)
            }
        } else {
            NotificationManager.shared.cancelNotifications()
        }
    }
    
    private func handleNotificationTimeChange() {
        if notificationsEnabled, let date = notificationDate {
            NotificationManager.shared.scheduleDailyNotification(at: date)
        }
    }
}
