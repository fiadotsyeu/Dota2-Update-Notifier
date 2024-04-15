//
//  NavBarView.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import SwiftUI

struct NavBarView: View {
    @State var selectTab = "News"
    
    let tabs = ["News", "Patches", "Favorites", "Settings"]
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectTab) {
                NewsListView()
                    .tag("News")
                Text("Patches")
                    .tag("Patches")
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
            .background(.gray)
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
                            .frame(width: 20, height: 20)
                            .colorMultiply(.red)
                    } else {
                        Image(tab)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .colorMultiply(.black)
                    }
                    if selected == tab {
                        Text(tab)
                            .foregroundColor(.black)
                    }
                
                }
            }
        }
        .opacity(selected == tab ? 1 : 0.7)
        .padding(.vertical, 10)
        .padding(.horizontal, 17)
        .background(selected == tab ? .white : .gray)
        .clipShape(Capsule())
    }
}


#Preview {
    NavBarView()
}
