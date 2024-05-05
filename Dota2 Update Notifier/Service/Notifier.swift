//
//  Notifier.swift
//  Dota2 Update Notifier
//
//  Created by Andrei Fiadotsyeu on 30.04.2024.
//

import Foundation
import UserNotifications
import SwiftUI

class Notifier {
    var modelData = ModelData()
    @AppStorage("newsNotifications") private var notificationsNews = true
    @AppStorage("patchesNotifications") private var notificationsPatches = true
    @AppStorage("updatesNotifications") private var notificationsUpdates = true
    @AppStorage("internationalNotifications") private var notificationsInternational = true
    
    func postNotification() {
        let lastNewsItem = modelData.newsItems[0]
        
        let content = UNMutableNotificationContent()
        content.title = lastNewsItem.title
        content.sound = UNNotificationSound.default
        
        switch lastNewsItem.tag {
        case "The International":
            if notificationsInternational == true {
                content.body = NSLocalizedString("New information about The International is here! Check it out!", comment: "")
            }
        case "Patch":
            if notificationsPatches == true {
                content.body = NSLocalizedString("New patch available! Check out what's changed!", comment: "")
            }
        case "Update":
            if notificationsUpdates == true {
                content.body = NSLocalizedString("New updates are already waiting for you! Check them out!", comment: "")
            }
        default:
            if notificationsNews == true {
                content.body = NSLocalizedString("The latest news are already in your app. Be the first to know!", comment: "")
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
