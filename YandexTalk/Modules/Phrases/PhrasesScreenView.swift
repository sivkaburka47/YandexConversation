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
    @State private var isShowingAddPhraseSheet = false
    @State private var newPhraseText = ""

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
                                .accessibilityLabel(phrase.isPinned ? "Открепить фразу: \(phrase.text)" : "Закрепить фразу: \(phrase.text)")
                                .accessibilityAddTraits(.isButton)

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
                            .accessibilityLabel("Воспроизвести фразу: \(phrase.text)")
                            Spacer()

                            Button(action: {
                                // Добавить выпадаются список
                            }) {
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90))
                                    .padding(.trailing, 4)
                            }
                            .accessibilityLabel("Дополнительные действия для фразы: \(phrase.text)")
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }

            Button(action: {
                isShowingAddPhraseSheet = true
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
            .accessibilityLabel("Добавить новую фразу")
        }
        .sheet(isPresented: $isShowingAddPhraseSheet) {
            NavigationView {
                VStack {
                    TextEditor(text: $newPhraseText)
                        .padding()
                        .frame(minHeight: 200)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding()
                        .accessibilityLabel("Введите новую фразу")

                    Spacer()
                }
                .navigationTitle("Новая фраза")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Отмена") {
                            isShowingAddPhraseSheet = false
                            newPhraseText = ""
                        }
                        .accessibilityLabel("Отмена добавления фразы")
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Добавить") {
                            if !newPhraseText.trimmingCharacters(in: .whitespaces).isEmpty {
                                viewModel.addPhrase(text: newPhraseText)
                            }
                            isShowingAddPhraseSheet = false
                            newPhraseText = ""
                        }
                        .disabled(newPhraseText.trimmingCharacters(in: .whitespaces).isEmpty)
                        .accessibilityLabel("Добавить фразу")
                    }
                }
            }
        }
    }
}
