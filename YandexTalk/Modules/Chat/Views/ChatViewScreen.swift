//
//  ChatViewScreen.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI

struct ChatViewScreen: View {
    @StateObject private var viewModel = ChatViewModel()
    
    @Binding var navigationPath: NavigationPath
    @Binding var showMicrophoneScreen: Bool
    @Binding var microphoneText: String
    @State private var isFlipped = false
    @State private var isAnimatingMicrophone: Bool = false
    @State private var showPhrasesTable = false
    @State private var isShowingChatsList = false


    init(navigationPath: Binding<NavigationPath>,
         showMicrophoneScreen: Binding<Bool>,
         microphoneText: Binding<String>) {
        _navigationPath = navigationPath
        _viewModel = StateObject(wrappedValue: ChatViewModel())
        _showMicrophoneScreen = showMicrophoneScreen
        _microphoneText = microphoneText
    }
    
    var body: some View {
        VStack(spacing: 8) {
            topBar
            segmentedPicker
            ZStack {
                Color(red: 230/255, green: 235/255, blue: 241/255)
                    .ignoresSafeArea(edges: .bottom)
                
                if viewModel.messages.isEmpty {
                    VStack {
                        microphoneStatus
                        Spacer()
                        messagePrompt
                        Spacer()
                    }
                } else {
                    ChatMessagesView(messages: viewModel.messages,
                                     showMicrophoneScreen: $showMicrophoneScreen,
                                     microphoneText: $microphoneText)
                }
            }
            bottomInputBar
            if showPhrasesTable {
                PhrasesGridView(
                    pinnedMessages: viewModel.pinnedMessages,
                    onPhraseTap: { tappedText in
                        viewModel.insertPinnedMessageText(tappedText)
                        showPhrasesTable = false
                    }
                )
            }
        }
        .onChange(of: viewModel.requestedAction) { _, newValue in
            guard let action = newValue else { return }
            
            switch action {
            case .didTapMicrophoneToast:
                let initialMicrophoneText = """
                Включен микрофон.
                Говорите.
                Постарайтесь говорить
                разборчиво и не очень быстро
                """
                viewModel.message = initialMicrophoneText
                viewModel.sendMessage()
                
                microphoneText = initialMicrophoneText
                
            case .didTapPlusButton:
                navigationPath.append("phrases")
                
            case .didSendMessage(let message):
                viewModel.sendMessage()
            }
            viewModel.requestedAction = nil
        }
        .rotationEffect(.degrees(isFlipped ? 180 : 0))
        .animation(.easeInOut, value: isFlipped)
        .overlay(
            Button(action: {
                withAnimation(.easeInOut(duration: 0.6)) {
                    isFlipped.toggle()
                    viewModel.toggleSender()
                }
            }) {
                Image("refreshIcon")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding()
                    .background(Color("knopProz"))
                    .clipShape(Circle())
            }
                .padding(.trailing)
            , alignment: .trailing
        )
        .onAppear {
            viewModel.startListening()
        }
        .onDisappear {
            viewModel.stopListening()
        }
        .onChange(of: viewModel.isMicrophoneEnabled) { _, isRecording in
            withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                isAnimatingMicrophone = isRecording
            }
            if !isRecording {
                isAnimatingMicrophone = false
            }
        }
        .onChange(of: showMicrophoneScreen) { _, isShowingMicrophoneScreen in
            if isShowingMicrophoneScreen {
                viewModel.stopListening()
            } else {
                viewModel.startListening()
            }
        }
        .sheet(isPresented: $isShowingChatsList) {
            ChatsListView(viewModel: viewModel)
        }
    }
}

// MARK: - View Components
extension ChatViewScreen {
    
    private var topBar: some View {
        HStack {
            Button(action: {
                Task {
                    await viewModel.fetchChats()
                    isShowingChatsList = true
                }
            }) {
                Image("chatIcon")
            }
            .accessibilityLabel("Список чатов")

            Spacer()
            Button(action: {
                
            }) {
                Image("microDark")
                    .font(.system(size: 28))
                    .foregroundColor(.green)
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    .background(Circle().fill(Color("salatoviy")))
                    .scaleEffect(isAnimatingMicrophone ? 1.1 : 1.0)
            }
            .accessibilityLabel(viewModel.isMicrophoneEnabled ? "Микрофон включен" : "Микрофон выключен")

            Spacer()
            Button(action: {
                viewModel.clearChatHistory()
                Task { await viewModel.createNewChat() }
            }) {
                Image("plusBtn")
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .accessibilityLabel("Создать новый чат")
    }
    
    private var segmentedPicker: some View {
        Picker("Режим", selection: $viewModel.selectedTab) {
            ForEach(ChatViewModel.ChatMode.allCases) { mode in
                Text(mode.rawValue)
                    .tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .accessibilityLabel("Выберите режим чата")
    }
    
    private var microphoneStatus: some View {
        VStack {
            Button(action: {
                viewModel.didTapMicrophoneToast()
            }, label: {
                HStack {
                    VStack {
                        Image("micro")
                            .frame(width: 21, height: 21)
                        Spacer()
                            .frame(height: 21)
                    }
                    
                    VStack {
                        HStack {
                            Text("Микрофон включен ")
                                .foregroundColor(.green)
                                .font(.system(size: 20, weight: .medium))
                            Spacer()
                        }
                        HStack {
                            Text("Сообщить собеседнику")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .regular))
                            Spacer()
                        }
                    }
                    
                    VStack {
                        Image("backIcon")
                            .frame(width: 21, height: 21)
                        Spacer()
                            .frame(height: 21)
                    }
                }
                .padding()
                .background(Color("korich"))
                .cornerRadius(12)
            })
            .accessibilityLabel("Сообщить собеседнику, что микрофон включен")
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var messagePrompt: some View {
        VStack(spacing: 18) {
            Spacer()
            Text("Печатайте сообщение, чтобы показать и озвучить собеседнику")
                .multilineTextAlignment(.center)
                .foregroundColor(Color("korich"))
                .font(.system(size: 20, weight: .regular))
                .padding(.horizontal)
            Image("downStrelka")
        }
        .padding(.horizontal, 64)
        .padding(.vertical, 24)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Поле для ввода сообщения")
    }
    
    private var bottomInputBar: some View {
        HStack(spacing: 8) {
            Button(action: {
                showPhrasesTable.toggle()
            }) {
                Image("list")
                    .padding(.leading, 12)
            }
            .accessibilityLabel("Показать быстрые фразы")

            
            TextField("Сообщение...", text: $viewModel.message)
                .accessibilityLabel("Поле ввода сообщения")
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .font(.system(size: 20, weight: .regular))
                .background(Color("bgminor"))
                .clipShape(RoundedRectangle(cornerRadius: 48))
            
            Button(action: {
                viewModel.sendMessage()
            }) {
                Image("sendIcon")
                    .padding(12)
                    .background(Color("action"))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 8)
    }
}


struct ChatsListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        NavigationView {
            List(viewModel.chats, id: \.id) { chat in
                VStack(alignment: .leading) {
                    Text("Chat ID: \(chat.id)")
                        .font(.headline)
                    Text("Created: \(chat.createTime)")
                        .font(.subheadline)
                    if let lastMessage = chat.lastMessage {
                        Text("Last Message: \(lastMessage)")
                            .font(.caption)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Чат с ID \(chat.id), создан \(chat.createTime)\(chat.lastMessage != nil ? ", последнее сообщение: \(chat.lastMessage!)" : "")")
            }
            .navigationTitle("Чаты")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                    .accessibilityLabel("Закрыть список чатов")
                }
            }
        }
    }
}
