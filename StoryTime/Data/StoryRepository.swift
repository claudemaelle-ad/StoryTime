//
//  StoryRepository.swift
//  StoryTime
//
//  Abstraction de la source de données. Les vues et le store ne savent pas
//  d'où viennent les histoires : JSON embarqué aujourd'hui, API ou SwiftData demain.
//

import Foundation

protocol StoryRepository {
    func fetchStories() async throws -> [Story]
}

enum StoryRepositoryError: LocalizedError {
    case fileNotFound(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            "Le fichier \(name).json est introuvable dans l'app."
        }
    }
}

/// Implémentation qui lit un fichier JSON embarqué dans le bundle de l'app.
struct BundleStoryRepository: StoryRepository {
    var fileName = "stories"
    var bundle = Bundle.main

    func fetchStories() async throws -> [Story] {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw StoryRepositoryError.fileNotFound(fileName)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Story].self, from: data)
    }
}
