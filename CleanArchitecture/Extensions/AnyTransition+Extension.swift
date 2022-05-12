//
//  AnyTransition+Extension.swift
//  TestArch
//
//  Created by Roman Syrota on 06.05.2022.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }
}
