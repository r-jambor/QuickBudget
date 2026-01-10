//
//  SettingsModel.swift
//  QuickBudget
//
//  Created by Richard Jambor on 28.10.2025.
//

import Foundation
import SwiftUI

@Observable
class SettingsModel {
    var currency: String = "CZK"
    var notificationEnabled: Bool = false
    var notificationDate: Date? = nil
}
