//
//  MicrophoneScreenView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI

struct MicrophoneScreen: View {
    @State private var isFlipped = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Spacer()
            Text("Включен микрофон.\nГоворите.\nПостарайтесь говорить\nразборчиво и не очень быстро")
                .font(.system(size: 48, weight: .heavy))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image("krest")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray5))
                        .clipShape(Circle())
                }
                .padding(.trailing, 16)
            }

            Button(action: {
                print("Воспроизвести")
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
            }
            .padding(.trailing)
            , alignment: .trailing
        )
    }
}
