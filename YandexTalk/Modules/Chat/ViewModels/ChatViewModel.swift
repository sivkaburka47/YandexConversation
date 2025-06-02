//
//  ChatViewModel.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI
import Combine
import Foundation
import Speech
import AVFoundation
import Alamofire
    
struct GetChatsEndpoint: APIEndpoint {
    let path = "/Chat"
    let method: HTTPMethod = .get
    let parameters: Parameters? = nil
    let headers: HTTPHeaders? = nil
}

struct CreateChatEndpoint: APIEndpoint {
    let path = "/Chat"
    let method: HTTPMethod = .post
    let parameters: Parameters? = nil
    let headers: HTTPHeaders? = nil
}

struct Chat: Codable {
    let id: String
    let createTime: String
    let lastMessage: String?
}

struct CreateChatResponse: Codable {
    let id: String
    let createTime: String
    let lastMessage: String?
}

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
    @Published var chats: [CreateChatResponse] = []
    
    private var isHandlingMessageSend = false
    
    private var userNameMap: [String: String] = [:]
    private var userCounter = 1
    
    enum SenderType: String {
        case me = "me"
        case other = "other"
    }
    
    private let speechRecognizer: SpeechRecognizerManager
    private let httpClient = AlamofireHTTPClient()
    
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
    
    func clearChatHistory() {
        messages = []
    }
    
    // MARK: - API Methods
    
    func fetchChats() async {
        do {
            let chats: [CreateChatResponse] = try await httpClient.sendRequest(endpoint: GetChatsEndpoint() as APIEndpoint, requestBody: nil as Never?)
            DispatchQueue.main.async {
                self.chats = chats
            }
        } catch {
            print("Error fetching chats: \(error)")
        }
    }
    
    func createNewChat() async {
        do {
            let newChatResponse: CreateChatResponse = try await httpClient.sendRequest(endpoint: CreateChatEndpoint() as APIEndpoint, requestBody: nil as Never?)
        } catch {
            print("Error creating new chat: \(error)")
        }
    }
}
