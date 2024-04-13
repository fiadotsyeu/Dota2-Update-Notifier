//
//  ContentView.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavBarView()
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
