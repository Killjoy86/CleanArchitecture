//
//  CleanArchitectureApp.swift
//  CleanArchitecture
//
//  Created by Roman Syrota on 11.05.2022.
//

import SwiftUI

@main
struct CleanArchitectureApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var application = Application.shared
    
    var body: some Scene {
        WindowGroup {
            application.initialView
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("didFinishLaunchingWithOptions")
        return true
    }
}

