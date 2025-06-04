//
//  OnboardingView.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 01.06.2025.
//

import SwiftUI

struct OnboardingThirdView: View {
    @StateObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Spacer()
        
        VStack(spacing: 56) {
            Image("LogoThree")
                .accessibilityLabel("Иллюстрация функции быстрых фраз")
            
            VStack(spacing: 16) {
                Text("Быстрые фразы под рукой")
                    .onboardTitleStyle()
                    .multilineTextAlignment(.center)
                Text("Показывайте или озвучивайте заранее сохранённые фразы.")
                    .textBodyStyle()
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 32)
        
        Spacer()
        
        VStack(spacing: 0) {
            OnboardingContinueButton(action: {
                viewModel.didTapStartButton()
            }, title: "Начать")
            OnboardingSkipButton(action: {
                viewModel.didTapSkipButton()
            })
            .hidden()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    OnboardingThirdView(viewModel: OnboardingViewModel())
}
