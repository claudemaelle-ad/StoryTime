//
//  StoryEnums.swift
//  StoryTime
//
//  Valeurs typées : le JSON contient "orange" ou "animaux",
//  le code manipule des enums (pas de faute de frappe possible).
//

import SwiftUI

nonisolated enum StoryCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case animaux
    case aventure
    case magie
    case nature

    var id: String { rawValue }

    var label: String {
        switch self {
        case .animaux: "Animaux"
        case .aventure: "Aventure"
        case .magie: "Magie"
        case .nature: "Nature"
        }
    }

    var symbol: String {
        switch self {
        case .animaux: "pawprint.fill"
        case .aventure: "map.fill"
        case .magie: "wand.and.stars"
        case .nature: "leaf.fill"
        }
    }
}

nonisolated enum StoryTheme: String, Codable, Sendable {
    case orange
    case blue
    case green
    case purple
    case pink

    /// Traduction du thème JSON en couleur SwiftUI.
    var color: Color {
        switch self {
        case .orange: .orange
        case .blue: .blue
        case .green: .green
        case .purple: .purple
        case .pink: .pink
        }
    }
}
