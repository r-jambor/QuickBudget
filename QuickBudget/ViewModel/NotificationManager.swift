//
//  NotificationManager.swift
//  QuickBudget
//
//  Created by Richard Jambor on 01.11.2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    /// Požádá o povolení posílat notifikace
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notifications permission: \(success ? "granted" : "denied")")
            }
        }
    }
    
    /// Naplánuje denní notifikaci na daný čas
    func scheduleDailyNotification(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "QuickBudget"
        content.body = "💰 Don't forget to allocate your money today! 💰"
        content.sound = .default
        
        // extrahuj hodinu a minutu z Date
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        
        // nejdřív smaž staré notifikace
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily notification scheduled for \(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0)")
            }
        }
    }
    
    /// Zruší všechny naplánované notifikace
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
