//
//  StoryPageView.swift
//  StoryTime
//
//  Une page de lecture : illustration + texte en grande police arrondie.
//

import SwiftUI

struct StoryPageView: View {
    let page: StoryPage
    let theme: StoryTheme

    var body: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 0)

            if let symbol = page.symbol {
                Image(systemName: symbol)
                    .font(.system(size: 96))
                    .foregroundStyle(theme.color.gradient)
                    .frame(height: 130)
                    .accessibilityHidden(true)
            }

            Text(page.text)
                .font(.title2)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .minimumScaleFactor(0.6)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 28)
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StoryPageView(page: Story.sample.pages[0], theme: .orange)
}
