//
//  CharactersViewBuilder.swift
//  TestArch
//
//  Created by Roman Syrota on 01.05.2022.
//

import SwiftUI
import Domain

class ViewBuilder {
    
    var services: UseCaseProvider
    
    init(services: UseCaseProvider) {
        self.services = services
    }
}

final class CharactersViewBuilder: ViewBuilder {
    
    var listView: some View {
        let useCase = services.makeCharacterUseCase()
        let viewModel = CharactersListViewModel(
            characterUseCase: useCase,
            builder: self
        )
        return CharactersListView(viewModel: viewModel)
    }
    
    func detailsView(for character: Character) -> some View {
        let builder = CharacterDetailsBuilder(services: services)
        let useCase = services.makeCharacterUseCase()
        let viewModel = CharacterDetailsViewModel(
            character: character,
            characterUseCase: useCase,
            builder: builder
        )
        return CharacterDetailsView(viewModel: viewModel)
    }
}
