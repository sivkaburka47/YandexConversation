//
//  ChatMessagesView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI

struct ChatMessagesView: View {
    let messages: [ChatMessage]
    @Binding var showMicrophoneScreen: Bool
    @Binding var microphoneText: String

    private var groupedMessages: [(date: Date, messages: [ChatMessage])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: messages) { calendar.startOfDay(for: $0.timestamp) }
        return grouped
            .sorted { $0.key < $1.key }
            .map { (date: $0.key, messages: $0.value) }
    }

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(groupedMessages, id: \.date) { (date, messages) in
                        VStack(alignment: .center, spacing: 8) {
                            Text(dateFormatted(date))
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.horizontal)

                            ForEach(messages) { message in
                                messageBubble(message)
                                    .id(message.id)
                            }
                        }
                    }
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .onChange(of: messages.count) { _ in
                    if let last = messages.last {
                        DispatchQueue.main.async {
                            withAnimation {
                                scrollProxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
    }

    private func messageBubble(_ message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me {
                Spacer()
                Button(action: {
                    microphoneText = message.text
                    showMicrophoneScreen = true
                }) {
                    Image("speechIcon")
                        .font(.system(size: 28))
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .background(Circle().fill(Color("buttonSec")))
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                if message.sender != .me {
                    Text(message.sender.displayName)
                        .font(.caption)
                        .foregroundColor(.blue)
                }

                Text(message.text)
                    .font(.body)

                HStack {
                    Spacer()
                    Text(timeFormatted(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.65, alignment: .leading)
            .padding(12)
            .background(bubbleColor(for: message.sender))
            .cornerRadius(12)

            if message.sender == .other {
                Spacer()
            }
        }
        .padding(.horizontal)
    }

    private func bubbleColor(for sender: ChatMessage.Sender) -> Color {
        switch sender {
        case .me:
            return Color("priorityMessage")
        case .other:
            return Color.white
        }
    }

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }

    private func timeFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

