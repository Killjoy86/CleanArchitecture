//
//  CharactersListView.swift
//  TestArch
//
//  Created by Roman Syrota on 22.04.2022.
//

import SwiftUI
import Combine
import Domain

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
            return Text("idle")
                .mapToAnyView()
        case .loading:
            return activityIndicator
                .mapToAnyView()
        case .error(let error):
            return Text(error.message)
                .mapToAnyView()
        case .loaded(let characters):
            return list(of: characters)
                .mapToAnyView()
        }
    }
    
    private func list(of items: [Character]) -> some View {
        List(items) { item in
            NavigationLink(
                destination: viewModel.detailsView(for: item),
                label: { CharacterListItemView(item: item) }
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
//    static var previews: some View {
//        CharactersListView()
//    }
//}
