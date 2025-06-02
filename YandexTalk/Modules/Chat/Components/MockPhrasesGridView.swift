//
//  MockPhrasesGridView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import SwiftUI

struct MockPhrasesGridView: View {
    let phrases = [
        "Повторите еще раз", "У меня к вам вопрос", "Говорите медленно и разборчиво",
        "Напишите то, что вы сказали", "Здесь шумно: напишите", "Здесь шумно: давайте отойдем",
        "Здесь шумно: давайте отойдем", "Напишите то, что вы сказали", "Здесь шумно: напишите"
    ]

    let columns = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(phrases, id: \.self) { phrase in
                    Text(phrase)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
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

