//
//  Dota2_Update_NotifierApp.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import SwiftUI

@main
struct Dota2_Update_NotifierApp: App {
    @State private var modelData = ModelData()
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environment(modelData)
                .preferredColorScheme(darkMode ? .dark : .light)
        }
    }
}
