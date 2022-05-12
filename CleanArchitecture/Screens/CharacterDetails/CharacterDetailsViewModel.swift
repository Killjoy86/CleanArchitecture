//
//  CharacterDetailsViewModel.swift
//  TestArch
//
//  Created by Roman Syrota on 01.05.2022.
//

import Foundation
import Domain
import Combine

class CharacterDetailsViewModel: ObservableObject {
    
    @Published private(set) var state: Loadable<Character> = .idle
    
    private let character: Character
    private let builder: CharacterDetailsBuilder
    private let characterUseCase: CharacterUseCase
    
    private var bag = Set<AnyCancellable>()
    
    private let loading = ActivityIndicator()
    
    init(character: Character, characterUseCase: CharacterUseCase, builder: CharacterDetailsBuilder) {
        self.character = character
        self.characterUseCase = characterUseCase
        self.builder = builder
        self.state = .loaded(character)
        
        loading
            .compactMap { $0 ? .loading : nil }
            .assign(to: \.state, on: self)
            .store(in: &bag)
    }
    
    func onAppear() {
        
        characterUseCase
            .character(character.id)
            .trackActivity(loading)
            .map { .loaded($0) }
            .catch { Just(.error($0)) }
            .assign(to: \.state, on: self)
            .store(in: &bag)
    }
}
