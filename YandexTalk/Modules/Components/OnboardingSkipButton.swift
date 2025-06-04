//
//  OnboardingSkipButton.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 01.06.2025.
//

import SwiftUI

struct OnboardingSkipButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Пропустить")
                .textBodyStyle()
                .foregroundColor(.textOnControlMain)
                .padding(.vertical, 21)
                .frame(maxWidth: .infinity)
                .background(.clear)
                .cornerRadius(16)
        }
    }
}

#Preview {
    OnboardingSkipButton(action: {})
}

