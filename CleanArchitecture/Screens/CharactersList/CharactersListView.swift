//
//  CharactersListView.swift
//  TestArch
//
//  Created by Roman Syrota on 22.04.2022.
//

import SwiftUI
import Combine
import Domain
import Networking

struct CharactersListView: View {
    
    @ObservedObject var viewModel: CharactersListViewModel
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Breaking Bad")
        }
        .onAppear(perform: viewModel.onAppear)
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return EmptyView().mapToAnyView()
        case .loading:
            return activityIndicator.mapToAnyView()
        case .error(let error):
            return Text(error.message).mapToAnyView()
        case .loaded(let viewModels):
            return list(of: viewModels).mapToAnyView()
        }
    }
    
    private func list(of itemViewModels: [CharacterListItemViewModel]) -> some View {
        List(itemViewModels) { itemViewModel in
            NavigationLink(
                destination: viewModel.detailsView(for: itemViewModel),
                label: {
                    CharacterListItemView(viewModel: itemViewModel)
                }
            )
        }
    }
    
    private var activityIndicator: some View {
        Spinner(isActive: true, style: .large)
            .tintColor(.blue)
    }
}

//struct CharactersListView_Previews: PreviewProvider {
//
//    static var stubView: some View {
//        let networking: AppNetworking = .stubbedNetworking()
//        let services = Networking.UseCaseProvider(provider: networking)
//        let builder = CharactersViewBuilder(services: services)
//        let viewModel = CharactersListViewModel(
//            characterUseCase: services.makeCharacterUseCase(),
//            builder: builder
//        )
//        return CharactersListView(viewModel: viewModel)
//    }
//
//    static var previews: some View {
//        stubView
//    }
//}
