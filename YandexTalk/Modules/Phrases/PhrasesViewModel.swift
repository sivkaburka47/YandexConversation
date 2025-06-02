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

    private let httpClient: HTTPClient

    init(httpClient: HTTPClient = AlamofireHTTPClient()) {
        self.httpClient = httpClient
        Task {
            await loadAllPhrases()
        }
    }

    func loadAllPhrases() async {
        async let pinned = fetchPinnedMessages()
        async let all = fetchAllMessages()

        let combined = await (pinned + all)
        let unique = Dictionary(grouping: combined, by: \.id).compactMap { $0.value.first }

        self.phrases = unique
        sortPhrases()
    }

    private func fetchPinnedMessages() async -> [Phrase] {
        do {
            let pinnedMessages: [PinnedMessage] = try await httpClient.sendRequest(
                endpoint: MessageEndpoint.getPinnedMessages,
                requestBody: Optional<EmptyRequest>.none
            )
            return pinnedMessages.map {
                Phrase(id: $0.id.uuidString, text: $0.text, timestamp: Date(), isPinned: true)
            }
        } catch {
            print("Ошибка при получении pinned messages: \(error)")
            return []
        }
    }

    private func fetchAllMessages() async -> [Phrase] {
        do {
            let chats: [Chat] = try await httpClient.sendRequest(
                endpoint: MessageEndpoint.getAllChats,
                requestBody: Optional<EmptyRequest>.none
            )

            var allMessages: [Message] = []

            for chat in chats {
                let messages: [Message] = try await httpClient.sendRequest(
                    endpoint: MessageEndpoint.getMessages(chatId: chat.id),
                    requestBody: Optional<EmptyRequest>.none
                )
                allMessages.append(contentsOf: messages)
            }

            return allMessages.map {
                Phrase(
                    id: $0.id.uuidString,
                    text: $0.text,
                    timestamp: $0.createTime,
                    isPinned: $0.isPinned
                )
            }
        } catch {
            print("Ошибка при загрузке сообщений: \(error)")
            return []
        }
    }

    func togglePin(for phrase: Phrase) {
        guard let uuid = UUID(uuidString: phrase.id) else { return }

        Task {
            do {
                try await httpClient.sendRequestWithoutResponse(
                    endpoint: MessageEndpoint.togglePin(messageId: uuid),
                    requestBody: Optional<EmptyRequest>.none
                )

                if let index = phrases.firstIndex(where: { $0.id == phrase.id }) {
                    phrases[index].isPinned.toggle()
                    sortPhrases()
                }
            } catch {
                print("Ошибка togglePin: \(error)")
            }
        }
    }

    func addPhrase(text: String) {
        let newPhrase = Phrase(
            id: UUID().uuidString,
            text: text,
            timestamp: Date(),
            isPinned: false
        )

        phrases.insert(newPhrase, at: 0)
        sortPhrases()
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
