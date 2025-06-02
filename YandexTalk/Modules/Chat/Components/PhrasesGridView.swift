//
//  PhrasesGridView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import SwiftUI

struct PhrasesGridView: View {
    let pinnedMessages: [PinnedMessage]
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    let onPhraseTap: (String) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(pinnedMessages) { message in
                    Text(message.text)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .onTapGesture {
                            onPhraseTap(message.text)
                        }
                        .accessibilityLabel(message.text)
                        .accessibilityAddTraits(.isButton)
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
}
