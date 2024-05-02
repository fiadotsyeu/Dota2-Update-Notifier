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
    @AppStorage("language") private var selectedOptionlanguage = "en"
    
    var body: some View {
        let rssParser = RSSParser(modelData: modelData)
        var rssURLs = updateContentForAppLanguage(language: selectedOptionlanguage)
        
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
                            await rssParser.parseRSS(from: url)
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
        let rssURLs = updateContentForAppLanguage(language: selectedOptionlanguage)

        for url in rssURLs {
            Task {
                do {
                    await rssParser.parseRSS(from: url)
                    print("date: \(Date()), sync rss parser starting")
                    task.setTaskCompleted(success: true)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
