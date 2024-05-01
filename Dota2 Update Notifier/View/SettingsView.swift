//
//  SettingsView.swift
//  Dota2 Update Notifier
//
//  Created by user on 14.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("newsNotifications") private var notificationsNews = true
    @AppStorage("patchesNotifications") private var notificationsPatches = true
    @AppStorage("updatesNotifications") private var notificationsUpdates = true
    @AppStorage("internationalNotifications") private var notificationsInternational = true
    @AppStorage("darkMode") private var darkMode = false
    @AppStorage("language") private var selectedOptionlanguage = "en"
    
    var modelData = ModelData()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedStringKey("Notifications"))) {
                    Toggle(isOn: $notificationsNews) {
                        hStackOnOff(state: notificationsNews, text: LocalizedStringKey("News"))
                    }
                    Toggle(isOn: $notificationsPatches) {
                        hStackOnOff(state: notificationsPatches, text: LocalizedStringKey("Patches"))
                    }
                    Toggle(isOn: $notificationsUpdates) {
                        hStackOnOff(state: notificationsUpdates, text: LocalizedStringKey("Updates"))
                    }
                    Toggle(isOn: $notificationsInternational) {
                        hStackOnOff(state: notificationsInternational, text: LocalizedStringKey("The International"))
                    }
                }
                
                Section(header: Text(LocalizedStringKey("Appearance"))) {
                    Toggle(isOn: $darkMode) {
                        hStackOnOff(state: darkMode, text: LocalizedStringKey("Dark Mode"))
                    }
                }
                
                Section(header: Text(LocalizedStringKey("Language"))) {
                    Picker(selection: $selectedOptionlanguage, label: Text(LocalizedStringKey("Select a language"))) {
                        Text("EN").tag("en")
                        Text("CZ").tag("cs")
                        Text("UK").tag("uk")
                        Text("RU").tag("ru")
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
               // for tests
                Button(action: {modelData.clearDataInFile()}, label: {
                    Text("clear data news in file")
                })
            }
            .navigationTitle(LocalizedStringKey("Settings"))
        }
    }
}

struct hStackOnOff: View {
    var state: Bool
    var text: LocalizedStringKey
    
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
