//
//  CharacterDetailsView.swift
//  TestArch
//
//  Created by Roman Syrota on 01.05.2022.
//

import SwiftUI
import Combine
import Domain
import SDWebImageSwiftUI

struct CharacterDetailsView: View {
    
    @ObservedObject var viewModel: CharacterDetailsViewModel
    
    @State private var showDetail = false
    
    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
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
        case .loaded(let character):
            return characterView(character)
                .mapToAnyView()
        case .error(let error):
            return Text(error.localizedDescription)
                .mapToAnyView()
        }
    }
    
    private func characterView(_ char: Character) -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                icon(char)
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.3)) {
                        showDetail.toggle()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Show details")
                            .foregroundColor(showDetail ? .green : .blue)
                        Label("Show detail", systemImage: "chevron.up.circle")
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .rotationEffect(.degrees(showDetail ? 180 : 0))
                            .padding()
                            .foregroundColor(showDetail ? .green : .blue)
                        Spacer()
                    }
                }
                if showDetail {
                    detailView(char)
                        .transition(.moveAndFade)
                }
                Spacer()
            }
        }
        .navigationTitle(char.name)
    }
    
    private func detailView(_ char: Character) -> some View {
        VStack {
            Text(char.nickname)
                .font(.title)
            Text(char.birthday)
                .font(.headline)
        }
    }
    
    private func icon(_ char: Character) -> some View {
        char
            .image
            .map {
                WebImage(url: $0, options: .continueInBackground)
                    .resizable()
                    .placeholder(Image(systemName: "photo"))
                    .indicator(.progress)
                    .transition(.fade)
                    .scaledToFit()
            }
    }
    
    private var activityIndicator: some View {
        Spinner(isActive: true, style: .large)
            .tintColor(.blue)
    }
}
