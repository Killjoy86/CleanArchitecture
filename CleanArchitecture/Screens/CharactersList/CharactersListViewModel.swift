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
import Networking

class CharactersListViewModel: ObservableObject {
    
    private let onAppearEvent = PassthroughSubject<Void, Never>()
    @Published private(set) var state: Loadable<[CharacterListItemViewModel]> = .idle
    
    private let characterUseCase: CharacterUseCase
    private let builder: CharactersViewBuilder
    
    private var bag = Set<AnyCancellable>()
    private let loading = ActivityIndicator()
    
    init(characterUseCase: CharacterUseCase, builder: CharactersViewBuilder) {
        self.characterUseCase = characterUseCase
        self.builder = builder
        self.bind()
    }
    
    private func bind() {
        loading
            .compactMap { $0 ? .loading : nil }
            .assign(to: \.state, on: self)
            .store(in: &bag)
        
        onAppearEvent.flatMap {
            return self.characterUseCase
                .characters()
        }
        .trackActivity(loading)
        .map { .loaded($0.map(CharacterListItemViewModel.init)) }
        .catch { Just(.error($0)) }
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    func onAppear() {
        onAppearEvent.send()
    }
    
    func detailsView(for viewModel: CharacterListItemViewModel) -> some View {
        return builder
            .detailsView(for: viewModel.item)
    }
}
