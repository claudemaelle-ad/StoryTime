//
//  SpeechReader.swift
//  StoryTime
//
//  Lecture à voix haute avec la synthèse vocale d'iOS (AVSpeechSynthesizer).
//  Aucun fichier audio, aucune dépendance. Isolé dans un objet dédié :
//  le lecteur ne connaît pas AVFoundation, et l'implémentation pourra
//  être remplacée par de vrais enregistrements audio plus tard.
//

import AVFoundation
import Observation

@Observable
final class SpeechReader: NSObject {
    /// Vrai pendant qu'une page est lue : pilote l'icône du bouton.
    private(set) var isSpeaking = false

    @ObservationIgnored private let synthesizer = AVSpeechSynthesizer()
    @ObservationIgnored private var currentUtterance: AVSpeechUtterance?

    override init() {
        super.init()
        synthesizer.delegate = self
        // Lecture audible même si l'iPhone est en mode silencieux.
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
    }

    func speak(_ text: String) {
        stop()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9   // un peu plus lent, pour les enfants
        utterance.pitchMultiplier = 1.1                              // voix légèrement plus douce
        currentUtterance = utterance
        isSpeaking = true
        synthesizer.speak(utterance)
    }

    func stop() {
        currentUtterance = nil
        isSpeaking = false
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    /// Appelé quand une lecture se termine ou est annulée.
    /// On ignore les notifications d'une ancienne lecture (après un changement de page).
    private func utteranceEnded(_ id: ObjectIdentifier) {
        guard let currentUtterance, ObjectIdentifier(currentUtterance) == id else { return }
        self.currentUtterance = nil
        isSpeaking = false
    }
}

extension SpeechReader: AVSpeechSynthesizerDelegate {
    // Le délégué peut être appelé hors du thread principal :
    // on revient explicitement sur le MainActor avant de toucher à l'état.
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        let id = ObjectIdentifier(utterance)
        Task { @MainActor in self.utteranceEnded(id) }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        let id = ObjectIdentifier(utterance)
        Task { @MainActor in self.utteranceEnded(id) }
    }
}
