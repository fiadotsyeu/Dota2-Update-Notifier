//
//  NavBarView.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import SwiftUI

struct NavBarView: View {
    @State var selectTab = "News"
    
    let tabs = ["News", "Updates", "Heart", "Settings"]
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectTab) {
                NewsList()
                    .tag("News")
                Text("Updates")
                    .tag("Updates")
                Text("Favorits")
                    .tag("Heart")
                Text("Settings")
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
                    Image(tab)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .colorInvert()
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
