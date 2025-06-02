//
//  PhrasesViewModel.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import SwiftUI

@MainActor
class PhrasesViewModel: ObservableObject {
    @Published var phrases: [Phrase] = []

    init() {
        loadMockPhrases()
    }

    func loadMockPhrases() {
        phrases = [
            Phrase(id: UUID().uuidString, text: "Я не слышу. Повторите, пожалуйста, что вы сказали.", timestamp: Date(), isPinned: true),
            Phrase(id: UUID().uuidString, text: "Я не слышу. Говорите, пожалуйста в телефон: он переведет вашу речь в печатный текст. Произносите слова медленно и разборчиво, используйте простую конструкцию предложений.", timestamp: Date(), isPinned: false),
            Phrase(id: UUID().uuidString, text: "Кто последний?", timestamp: Date(), isPinned: false),
            Phrase(id: UUID().uuidString, text: "Какая следующая остановка?", timestamp: Date(), isPinned: false),
            Phrase(id: UUID().uuidString, text: "Что происходит? Пожалуйста, объясните. Я не слышу.", timestamp: Date(), isPinned: false),
            Phrase(id: UUID().uuidString, text: "Я не слышу. Повторите, пожалуйста, что вы сказали.", timestamp: Date(), isPinned: false),
            Phrase(id: UUID().uuidString, text: "Кто последний?", timestamp: Date(), isPinned: false),
            Phrase(id: UUID().uuidString, text: "Какая следующая остановка?", timestamp: Date(), isPinned: false),
            Phrase(id: UUID().uuidString, text: "Что происходит? Пожалуйста, объясните. Я не слышу.", timestamp: Date(), isPinned: false),
            Phrase(id: UUID().uuidString, text: "Я не слышу. Повторите, пожалуйста, что вы сказали.", timestamp: Date(), isPinned: false)
        ]
    }

    func togglePin(for phrase: Phrase) {
        if let index = phrases.firstIndex(where: { $0.id == phrase.id }) {
            phrases[index].isPinned.toggle()
            sortPhrases()
        }
    }

    private func sortPhrases() {
        phrases.sort {
            if $0.isPinned != $1.isPinned {
                return $0.isPinned && !$1.isPinned
            } else {
                return $0.timestamp < $1.timestamp
            }
        }
    }
}
