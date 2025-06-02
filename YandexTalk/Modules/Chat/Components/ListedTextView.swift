//
//  ListedTextView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import SwiftUI

struct ListenTextView: View {
    @Binding var text: String

    var body: some View {
        ScrollView {
            TextEditor(text: $text)
                .font(.system(size: 28, weight: .regular))
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(12)
                .disabled(true) // Не позволяет редактировать
                .scrollDisabled(false)
                .frame(maxWidth: .infinity, minHeight: 400, alignment: .topLeading)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2))
                )
                .accessibilityLabel("Прослушиваемый текст: \(text)")
        }
        .padding()
        .background(Color.white)
    }
}
