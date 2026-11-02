//
//  ReaderView.swift
//  StoryTime
//
//  Écran de lecture : pagination par swipe (TabView en style page),
//  progression et boutons précédent / suivant.
//

import SwiftUI

struct ReaderView: View {
    let story: Story

    @Environment(\.dismiss) private var dismiss

    /// État local à l'écran : index de la page affichée.
    @State private var currentPage = 0

    /// Lecture à voix haute : propre à cet écran, détruite en le quittant.
    @State private var speech = SpeechReader()

    private var pageCount: Int { story.pages.count }
    private var isFirstPage: Bool { currentPage == 0 }
    private var isLastPage: Bool { currentPage >= pageCount - 1 }
    private var progress: Double {
        pageCount == 0 ? 0 : Double(currentPage + 1) / Double(pageCount)
    }

    var body: some View {
        Group {
            if story.pages.isEmpty {
                ContentUnavailableView("Histoire vide", systemImage: "book.closed")
            } else {
                VStack(spacing: 0) {
                    TabView(selection: $currentPage) {
                        ForEach(Array(story.pages.enumerated()), id: \.element.id) { index, page in
                            StoryPageView(page: page, theme: story.theme)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    controls
                }
            }
        }
        .background(story.theme.color.opacity(0.12).ignoresSafeArea())
        .navigationTitle(story.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    toggleSpeech()
                } label: {
                    Image(systemName: speech.isSpeaking ? "stop.fill" : "speaker.wave.2.fill")
                        .contentTransition(.symbolEffect(.replace))
                }
                .tint(story.theme.color)
                .disabled(story.pages.isEmpty)
                .accessibilityLabel(speech.isSpeaking ? "Arrêter la lecture" : "Lire la page à voix haute")
            }
        }
        .onChange(of: currentPage) { _, newPage in
            // Si une lecture est en cours, on enchaîne sur la nouvelle page.
            if speech.isSpeaking {
                speech.speak(story.pages[newPage].text)
            }
        }
        .onDisappear {
            speech.stop()
        }
    }

    private func toggleSpeech() {
        if speech.isSpeaking {
            speech.stop()
        } else if story.pages.indices.contains(currentPage) {
            speech.speak(story.pages[currentPage].text)
        }
    }

    private var controls: some View {
        VStack(spacing: 16) {
            ProgressView(value: progress)
                .tint(story.theme.color)
                .animation(.easeInOut, value: currentPage)

            HStack {
                Button {
                    withAnimation { currentPage -= 1 }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .disabled(isFirstPage)
                .accessibilityLabel("Page précédente")

                Spacer()

                Text("Page \(currentPage + 1) / \(pageCount)")
                    .font(.headline.monospacedDigit())
                    .fontDesign(.rounded)
                    .foregroundStyle(.secondary)

                Spacer()

                if isLastPage {
                    Button {
                        dismiss()
                    } label: {
                        Label("Fini !", systemImage: "checkmark")
                            .font(.headline)
                            .frame(height: 44)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                } else {
                    Button {
                        withAnimation { currentPage += 1 }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2.bold())
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                    .accessibilityLabel("Page suivante")
                }
            }
            .tint(story.theme.color)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

#Preview {
    NavigationStack {
        ReaderView(story: .sample)
    }
}
