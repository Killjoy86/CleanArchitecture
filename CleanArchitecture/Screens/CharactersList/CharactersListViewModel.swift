//
//  CharactersListView.swift
//  TestArch
//
//  Created by Roman Syrota on 28.04.2022.
//

import Foundation
import Domain
import Combine
import SwiftUI

class CharactersListViewModel: ObservableObject {
    
    @Published private(set) var state: Loadable<[Character]> = .idle
    
    private let characterUseCase: CharacterUseCase
    private let builder: CharactersViewBuilder
    
    private var bag = Set<AnyCancellable>()
    
    private let loading = ActivityIndicator()
    
    init(characterUseCase: CharacterUseCase, builder: CharactersViewBuilder) {
        self.characterUseCase = characterUseCase
        self.builder = builder
        
        loading
            .compactMap { $0 ? .loading : nil }
            .assign(to: \.state, on: self)
            .store(in: &bag)
    }
    
    func onAppear() {
        
        characterUseCase
            .characters()
            .trackActivity(loading)
            .map { .loaded($0) }
            .catch { Just(.error($0)) }
            .assign(to: \.state, on: self)
            .store(in: &bag)
    }
    
    func refresh() {
        
        characterUseCase
            .characters()
            .map { .loaded($0) }
            .catch { Just(.error($0)) }
            .assign(to: \.state, on: self)
            .store(in: &bag)
    }
    
    func detailsView(for item: Character) -> some View {
        return builder.detailsView(for: item)
    }
}
