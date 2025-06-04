//
//  OnboardingContinueButton.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 01.06.2025.
//

import SwiftUI

struct OnboardingContinueButton: View {
    let action: () -> Void
    let title: String
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .bodyMediumStyle()
                .foregroundColor(.textOnControlMain)
                .padding(.vertical, 21)
                .frame(maxWidth: .infinity)
                .background(.action)
                .cornerRadius(16)
        }
    }
}

#Preview {
    OnboardingContinueButton(action: {}, title: "")
}
