//
//  Notifier.swift
//  Dota2 Update Notifier
//
//  Created by Andrei Fiadotsyeu on 30.04.2024.
//

import Foundation
import UserNotifications

class Notifier {
    var modelData = ModelData()
    
    func postNotification() {
        let lastNewsItem = modelData.newsItems[0]
        
        let content = UNMutableNotificationContent()
        content.title = lastNewsItem.title
        content.sound = UNNotificationSound.default
        
        switch lastNewsItem.tag {
        case "The International":
            content.body = "New information about The International is here! Check it out!"
        case "Patch":
            content.body = "New patch available! Check out what's changed!"
        case "Update":
            content.body = "New updates are already waiting for you! Check them out!"
        default:
            content.body = "The latest news are already in your app. Be the first to know."
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
