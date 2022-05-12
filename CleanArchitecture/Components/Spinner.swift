//
//  Spinner.swift
//  TestArch
//
//  Created by Roman Syrota on 02.05.2022.
//

import Foundation
import SwiftUI

struct Spinner: UIViewRepresentable {
    
    var color: Color = .gray
    var isActive: Bool
    var style: UIActivityIndicatorView.Style
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.hidesWhenStopped = true
        return spinner
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.color = UIColor(color)
        isActive ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

extension Spinner {
    
    public func tintColor(_ color: Color) -> Spinner {
        var view = self
        view.color = color
        return view
    }
}
