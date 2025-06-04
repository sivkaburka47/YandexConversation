//
//  OnboardingView.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 01.06.2025.
//

import SwiftUI

struct OnboardingSecondView: View {
    @StateObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Spacer()
        
        VStack(spacing: 56) {
            Image("LogoSec")
                .accessibilityLabel("Иллюстрация функции чтения речи")
            
            VStack(spacing: 16) {
                Text("Читайте речь вокруг вас")
                    .onboardTitleStyle()
                    .multilineTextAlignment(.center)
                Text("Откройте приложение, и оно начнёт превращеть в текст речь одного или более спикеров.\n\nУдобно, когда  нужно только слушать.")
                    .textBodyStyle()
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 32)
        
        Spacer()
        
        VStack(spacing: 0) {
            OnboardingContinueButton(action: {
                viewModel.didTapSecondContinueButton()
            }, title: "Далее")
            
            OnboardingSkipButton(action: {
                viewModel.didTapSkipButton()
            })
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    OnboardingSecondView(viewModel: OnboardingViewModel())
}
