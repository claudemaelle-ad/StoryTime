//
//  StoryTimeApp.swift
//  StoryTime
//
//  Point d'entrée : crée le store partagé et l'injecte dans l'environnement SwiftUI.
//

import SwiftUI

@main
struct StoryTimeApp: App {
    /// Source de vérité unique de l'app, détenue par l'App pour vivre aussi longtemps qu'elle.
    @State private var store = StoryStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .tint(.indigo)
        }
    }
}
