//
//  ChatViewModel.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI
import Combine

@MainActor
final class ChatViewModel: ObservableObject {

    enum ChatAction: Equatable {
        case didTapMicrophoneToast
        case didTapPlusButton
        case didSendMessage(String)
    }

    enum ChatMode: String, CaseIterable, Identifiable {
        case talk = "Разговаривать"
        case listen = "Слушать"

        var id: String { self.rawValue }
    }

    // MARK: - Published Properties
    @Published var message: String = ""
    @Published var selectedTab: ChatMode = .talk
    @Published var isMicrophoneEnabled: Bool = true
    @Published var requestedAction: ChatAction?

    // MARK: - Message Sending
    func sendMessage() {
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        print("Message sent: \(trimmed)")
        // TODO: Send message to backend or text-to-speech
        message = ""
    }

    func didTapMicrophoneToast() {
        requestedAction = .didTapMicrophoneToast
    }
    
}
