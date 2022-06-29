//
//  CharacterListItemViewModel.swift
//  CleanArchitecture
//
//  Created by Roman Syrota on 27.05.2022.
//

import Foundation
import Domain

class CharacterListItemViewModel: Identifiable {
    
    var id: Int { item.id }
    
    var item: Character
    
    init(item: Character) {
        self.item = item
    }
}
