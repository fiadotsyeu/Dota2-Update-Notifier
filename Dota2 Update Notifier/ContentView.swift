//
//  ContentView.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import SwiftUI
import UserNotifications
import BackgroundTasks

struct ContentView: View {
    @Environment(ModelData.self) var modelData
    let rssURLs = [URL(string: "https://www.dotabuff.com/blog.rss"),
                   URL(string: "https://store.steampowered.com/feeds/news/app/570/l=english")]
    
    var body: some View {
        let rssParser = RSSParser(modelData: modelData)
        
        NavBarView()
            .onAppear {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Permission approved!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
                for url in rssURLs {
                    Task {
                        do {
                            await rssParser.parseRSS(from: url!)
                            print("date: \(Date()), sync rss parser starting")
                        }
                    }
                }
            }
    }

    init() {
        registerBackgroundTask()
    }
        
    private func registerBackgroundTask() {
        let backgroundTaskIdentifier = "DreF.Dota2-Update-Notifier.backgroundTask"
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: backgroundTaskIdentifier,
            using: nil
        ) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
        
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 10 * 60) // "Every 10 minutes."
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Error registering background task: \(error)")
        }
    }
        
    private func handleBackgroundTask(task: BGProcessingTask) {
        let rssParser = RSSParser(modelData: modelData)
        
        for url in rssURLs {
            Task {
                do {
                    await rssParser.parseRSS(from: url!)
                    print("date: \(Date()), sync rss parser starting")
                    task.setTaskCompleted(success: true)
                } catch {
                    print("Error parsing RSS: \(error)")
                    task.setTaskCompleted(success: false)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
