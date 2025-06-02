//
//  PhrasesScreenView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI

struct PhrasesScreenView: View {
    @StateObject private var viewModel = PhrasesViewModel()
    @Binding var showMicrophoneScreen: Bool
    @Binding var microphoneText: String

    init(showMicrophoneScreen: Binding<Bool>,
         microphoneText: Binding<String>) {
        _viewModel = StateObject(wrappedValue: PhrasesViewModel())
        _showMicrophoneScreen = showMicrophoneScreen
        _microphoneText = microphoneText
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.phrases) { phrase in
                        HStack(alignment: .center, spacing: 12) {
                            Image(phrase.isPinned ? "screpActive" : "screpGray")
                                .onTapGesture {
                                    viewModel.togglePin(for: phrase)
                                }
                            
                            Button(action: {
                                microphoneText = phrase.text
                                showMicrophoneScreen = true
                            }) {
                                Text(phrase.text)
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()

                            Button(action: {
                                // Добавить выпадаются список
                            }) {
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90))
                                    .padding(.trailing, 4)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }

            Button(action: {
                // добавить фразы
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Добавить фразу")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("action"))
                .foregroundColor(.black)
                .cornerRadius(16)
                .padding()
            }
        }
    }
}
