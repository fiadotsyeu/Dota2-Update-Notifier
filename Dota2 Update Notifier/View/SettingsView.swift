//
//  SettingsView.swift
//  Dota2 Update Notifier
//
//  Created by user on 14.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsNews = false
    @State private var notificationsPatches = false
    @State private var notificationsInternational = false
    @State private var darkMode = false
    @State private var selectedOptionlanguage = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    Toggle(isOn: $notificationsNews) {
                        hStackOnOff(state: notificationsNews, text: "News")
                    }
                    Toggle(isOn: $notificationsPatches) {
                        hStackOnOff(state: notificationsPatches, text: "Patches")
                    }
                    Toggle(isOn: $notificationsInternational) {
                        hStackOnOff(state: notificationsInternational, text: "The International")
                    }
                }
                
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $darkMode) {
                        hStackOnOff(state: darkMode, text: "Dark Mode")
                    }
                }
                
                Section(header: Text("Language")) {
                    Picker(selection: $selectedOptionlanguage, label: Text("Select a language")) {
                        Text("ENG").tag(0)
                        Text("CZ").tag(1)
                        Text("UA").tag(2)
                        Text("RU").tag(3)
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct hStackOnOff: View {
    var state: Bool
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Text(state ? "On" : "Off")
                .font(.subheadline)
        }
    }
}


#Preview {
    SettingsView()
}
