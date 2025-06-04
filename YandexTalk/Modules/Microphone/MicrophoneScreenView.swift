//
//  MicrophoneScreenView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI
import AVFoundation

struct MicrophoneScreen: View {
    @State private var isFlipped = false
    @Environment(\.dismiss) private var dismiss
    let messageText: String
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            Spacer()
            Text(messageText)
                .font(.system(size: 48, weight: .heavy))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .accessibilityLabel("Распознанный текст: \(messageText)")
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    speechSynthesizer.stopSpeaking(at: .immediate)
                    dismiss()
                }) {
                    Image("krest")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                        .accessibilityLabel("Закрыть")
                }
                .padding(.trailing, 16)
            }

            Button(action: {
                speakText(messageText)
            }) {
                HStack(spacing: 8) {
                    Image("speechIcon")
                    Text("Воспроизвести")
                        .font(.system(size: 20, weight: .medium))
                        .padding(.vertical, 21)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("action"))
                .foregroundColor(.black)
                .cornerRadius(16)
                .accessibilityLabel("Воспроизвести распознанный текст")
            }
            .padding()
        }
        .rotationEffect(.degrees(isFlipped ? 180 : 0))
        .animation(.easeInOut, value: isFlipped)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .overlay(
            Button(action: {
                withAnimation(.easeInOut(duration: 0.6)) {
                    isFlipped.toggle()
                }
            }) {
                Image("refreshIcon")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding()
                    .background(Color("knopProz"))
                    .clipShape(Circle())
                    .accessibilityLabel("Поменять отправителя")
            }
            .padding(.trailing)
            , alignment: .trailing
        )
        .onDisappear {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    private func speakText(_ text: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудио сессии: \(error)")
            return
        }
        
        let utterance = AVSpeechUtterance(string: text)
        
        if let voice = AVSpeechSynthesisVoice(language: "ru-RU") {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice()
        }
        
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        
        speechSynthesizer.speak(utterance)
    }
}
