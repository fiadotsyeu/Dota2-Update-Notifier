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

    @Environment(ModelData.self) var modelData
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedStringKey("Notifications"))) {
                    Toggle(isOn: $notificationsNews) {
                        hStackOnOff(state: notificationsNews, text: LocalizedStringKey("News"))
                    }.tint(Color("ToggleColor"))
                    Toggle(isOn: $notificationsPatches) {
                        hStackOnOff(state: notificationsPatches, text: LocalizedStringKey("Patches"))
                    }.tint(Color("ToggleColor"))
                    Toggle(isOn: $notificationsUpdates) {
                        hStackOnOff(state: notificationsUpdates, text: LocalizedStringKey("Updates"))
                    }.tint(Color("ToggleColor"))
                    Toggle(isOn: $notificationsInternational) {
                        hStackOnOff(state: notificationsInternational, text: LocalizedStringKey("The International"))
                    }.tint(Color("ToggleColor"))
                }
                
                Section(header: Text(LocalizedStringKey("Appearance"))) {
                    Toggle(isOn: $darkMode) {
                        hStackOnOff(state: darkMode, text: LocalizedStringKey("Dark Mode"))
                    }.tint(Color("ToggleColor"))
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
                .onChange(of: selectedOptionlanguage) {
                    let rssParser = RSSParser(modelData: modelData)
                    var rssURLs = updateContentForAppLanguage(language: selectedOptionlanguage)
                    modelData.clearDataInFile()
                    rssURLs.forEach { url in
                        Task {
                            await rssParser.parseRSS(from: url)
                        }
                    }
                }
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

func updateContentForAppLanguage(language: String) -> [URL] {
    switch language {
    case "cs":
        return [URL(string: "https://cs.dotabuff.com/blog.rss"),
                URL(string: "https://store.steampowered.com/feeds/news/app/570/?l=czech")].compactMap { $0 }
    case "uk":
        return [URL(string: "https://uk.dotabuff.com/blog.rss"), // It's unclear why, but Ukrainian language only works with this link...
                URL(string: "https://store.steampowered.com/feeds/news/app/570/?cc=CZ&l=ukrainian&snr=1_2108_9__2107")].compactMap { $0 }
    case "ru":
        return [URL(string: "https://ru.dotabuff.com/blog.rss"),
                URL(string: "https://store.steampowered.com/feeds/news/app/570/?l=russian")].compactMap { $0 }
    default:
        return [URL(string: "https://www.dotabuff.com/blog.rss"),
                URL(string: "https://store.steampowered.com/feeds/news/app/570/?l=english")].compactMap { $0 }
    }
}


#Preview {
    SettingsView()
}
