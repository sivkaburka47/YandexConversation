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
    @Published var messages: [ChatMessage] = []
    @Published var currentSender: ChatMessage.Sender = .me

    private var userNameMap: [String: String] = [:]
    private var userCounter = 1

    enum SenderType: String {
            case me = "me"
            case other = "other"
        }
    
    // MARK: - Message Sending
    func sendMessage() {
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let newMessage = ChatMessage(sender: currentSender, text: trimmed, timestamp: Date())
        messages.append(newMessage)
        message = ""
    }

    func toggleSender() {
        currentSender = currentSender == .me ? .other : .me
    }

    func didTapMicrophoneToast() {
        requestedAction = .didTapMicrophoneToast
    }
    
}
