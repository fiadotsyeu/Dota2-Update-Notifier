//
//  NavBarView.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import SwiftUI

struct NavBarView: View {
    @State var selectTab = "News"
    
    let tabs = ["News", "Favorites", "Settings"]
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectTab) {
                NewsListView()
                    .tag("News")
                FavoritsView()
                    .tag("Favorites")
                SettingsView()
                    .tag("Settings")
            }
            
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    Spacer()
                    NavBarItem(tab: tab, selected: $selectTab)
                    Spacer()
                }
            }
            .padding(.bottom, 14)
            .padding(.horizontal, 4)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 90)
            .background(Color("MenuBG")).opacity(0.9)
            .ignoresSafeArea(.all)
        }
        .ignoresSafeArea(.all)
    }
}

struct NavBarItem: View {
    @State var tab: String
    @Binding var selected: String
    
    var body: some View {
        
        ZStack {
            Button {
                withAnimation(.spring) {
                    selected = tab
                }
            } label: {
                HStack {
                    if (tab == "Favorites" && selected == tab) {
                        Image("Favorites.fill")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .colorMultiply(.red)
                    } else {
                        Image(tab)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .colorMultiply(selected == tab ? Color("MenuBG") : .red)
                    }
                    if selected == tab {
                        Text(LocalizedStringKey(tab))
                            .foregroundColor(Color("MenuBG"))
                    }
                
                }
            }
        }
        .opacity(selected == tab ? 1 : 0.7)
        .padding(.vertical, 10)
        .padding(.horizontal, 17)
        .background(selected == tab ? .white : Color("MenuBG").opacity(0.0))
        .clipShape(Capsule())
    }
}


#Preview {
    NavBarView()
}
