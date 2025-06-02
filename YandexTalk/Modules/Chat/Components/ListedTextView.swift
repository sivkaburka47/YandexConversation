//
//  ListedTextView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 02.06.2025.
//

import SwiftUI

struct ListenTextView: View {
    let messages: [ChatMessage]
    

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
            .background(Color.white)
        }
        .background(Color.white)
    }

    private func messageBubble(_ message: ChatMessage) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(message.sender.displayName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                Text(message.text)
                    .font(.system(size: 30, weight: .regular))

            }
            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
            .padding(12)
        }
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Сообщение от \(message.sender.displayName), текст: \(message.text), отправлено в \(timeFormatted(message.timestamp))")
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

