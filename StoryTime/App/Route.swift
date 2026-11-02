//
//  Route.swift
//  StoryTime
//
//  Toutes les destinations de navigation de l'app, sous forme de valeurs.
//  Ajouter un écran = ajouter un case ici + une branche dans RootView.
//

import Foundation

nonisolated enum Route: Hashable, Sendable {
    case library
    case reader(Story)
}
