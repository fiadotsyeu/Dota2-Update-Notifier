//
//  FavoriteButton.swift
//  Dota2 Update Notifier
//
//  Created by user on 13.04.2024.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Image(isSet ? "Favorits.fill" : "Favorits")
                .resizable()
                .frame(width: 25, height: 25)
                .colorMultiply(isSet ? .red : .gray)
        }
    }
}

#Preview {
    FavoriteButton(isSet: .constant(true))
}
