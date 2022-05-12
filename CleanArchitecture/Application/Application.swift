//
//  Application.swift
//  TestArch
//
//  Created by Roman Syrota on 22.04.2022.
//

import SwiftUI
import Domain
import Networking

enum Phase {
    case dev
    case qa
    case prod
}

public struct AppEnvironment {
    let phase: Phase = .dev
}

struct Application {
    
    private let services: Domain.UseCaseProvider
    private let appEnvironment: AppEnvironment
    
    static let shared = Application(
        networking: .appNetworking(),
        appEnvironment: AppEnvironment()
    )
    
    private init(networking: AppNetworking, appEnvironment: AppEnvironment) {
        self.services = Networking.UseCaseProvider(provider: networking)
        self.appEnvironment = appEnvironment
    }
    
    var initialView: some View {
        let builder = CharactersViewBuilder(services: services)
        return builder.listView
    }
}
