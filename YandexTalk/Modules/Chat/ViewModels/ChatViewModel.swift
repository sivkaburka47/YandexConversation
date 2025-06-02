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
    
    private var isHandlingMessageSend = false

    private var userNameMap: [String: String] = [:]
    private var userCounter = 1

    enum SenderType: String {
            case me = "me"
            case other = "other"
        }
    
    private let speechRecognizer: SpeechRecognizerManager
    
    init(speechRecognizer: SpeechRecognizerManager = SpeechRecognizerManager()) {
        self.speechRecognizer = speechRecognizer
        
        speechRecognizer.requestAuthorization { granted in
            if !granted {
                print("Разрешения на микрофон или распознавание речи не предоставлены при запуске.")
            }
        }
        
        speechRecognizer.recognizedTextHandler = { [weak self] text, isFinal in
            guard let self = self, let text = text else { return }
            
            if self.isHandlingMessageSend {
                return
            }
            
            DispatchQueue.main.async {
                self.message = text
            }
        }
        
        speechRecognizer.errorHandler = { error in
            print("Ошибка распознавания речи: \(error)")
        }
        
        speechRecognizer.recordingDidStopHandler = { [weak self] in
            DispatchQueue.main.async {
                 self?.isMicrophoneEnabled = false
            }
        }
    }
    
    // MARK: - Message Sending
    func sendMessage() {
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isHandlingMessageSend = true

        let newMessage = ChatMessage(sender: currentSender, text: trimmed, timestamp: Date())
        messages.append(newMessage)
        message = ""

        stopListening()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.startListening()
            self.isHandlingMessageSend = false
        }
    }

    func toggleSender() {
        currentSender = currentSender == .me ? .other : .me
    }

    func didTapMicrophoneToast() {
        requestedAction = .didTapMicrophoneToast
    }
    
    func startListening() {
        do {
            try self.speechRecognizer.startRecording()
            self.isMicrophoneEnabled = true
        } catch {
            self.isMicrophoneEnabled = false
        }
    }
    
    func stopListening() {
        speechRecognizer.stopRecording()
    }
}
