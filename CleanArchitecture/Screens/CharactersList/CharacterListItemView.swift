//
//  CharacterListItemView.swift
//  TestArch
//
//  Created by Roman Syrota on 29.04.2022.
//

import SwiftUI
import Domain
import SDWebImageSwiftUI

struct CharacterListItemView: View {
    
    var item: Character
    
    var body: some View {
        HStack {
            icon
            title
        }
    }
    
    private var title: some View {
        Text(item.name)
            .font(.title)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
    
    private var icon: some View {
        return item
            .image
            .map {
                WebImage(url: $0, options: .continueInBackground)
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade)
                    .scaledToFill()
                    .frame(width: 100, height: 100, alignment: .top)
                    .clipShape(Circle())
            }
            
    }
}
