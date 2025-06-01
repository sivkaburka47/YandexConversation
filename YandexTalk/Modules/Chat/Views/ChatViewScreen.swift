//
//  ChatViewScreen.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI

struct ChatViewScreen: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack(spacing: 8) {
            topBar
            segmentedPicker
            ZStack {
                Color(red: 230/255, green: 235/255, blue: 241/255)
                    .ignoresSafeArea(edges: .bottom)

                VStack {
                    microphoneStatus
                    Spacer()
                    messagePrompt
                    Spacer()
                }
            }
            bottomInputBar
        }
    }
}

// MARK: - View Components
extension ChatViewScreen {

    private var topBar: some View {
        HStack {
            Image("chatIcon")
            Spacer()
            Button(action: {
                print("MicroDark button tapped")
            }) {
                Image("microDark")
                    .font(.system(size: 28))
                    .foregroundColor(.green)
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    .background(Circle().fill(Color("salatoviy")))
            }
            Spacer()
            Image("plusBtn")
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }

    private var segmentedPicker: some View {
        Picker("Режим", selection: $viewModel.selectedTab) {
            ForEach(ChatViewModel.ChatMode.allCases) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }

    private var microphoneStatus: some View {
        VStack {
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
                        Spacer()
                    }
                    HStack {
                        Text("Сообщить собеседнику")
                            .foregroundColor(.white)
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
                .padding(.horizontal)
            Image("downStrelka")
        }
        .padding(.horizontal, 64)
    }

    private var bottomInputBar: some View {
        HStack(spacing: 8) {
            Image("list")
                .padding(.leading, 12)

            TextField("Сообщение...", text: $viewModel.message)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .foregroundColor(Color("textminor"))
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

// MARK: - Preview
#Preview {
    ChatViewScreen()
}
