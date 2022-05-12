//
//  Loadable.swift
//  TestArch
//
//  Created by Roman Syrota on 02.05.2022.
//

import Foundation
import Domain

enum Loadable<T> {
    case idle
    case loading
    case loaded(T)
    case error(AppError)
}
