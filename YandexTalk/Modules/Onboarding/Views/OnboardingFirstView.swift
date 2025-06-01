//
//  OnboardingView.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 01.06.2025.
//

import SwiftUI

struct OnboardingFirstView: View {
    @StateObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Spacer()
        
        VStack(spacing: 56) {
            Image("logoFirst")
            
            VStack(spacing: 16) {
                Text("Разговаривайте с помощью текста")
                    .onboardTitleStyle()
                    .multilineTextAlignment(.center)
                Text("Приложение покажет на экране, что говорит собеседник. А вы можете написать ответ и озвучить его голосом.")
                    .textBodyStyle()
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 32)
        
        Spacer()
        
        VStack(spacing: 0) {
            OnboardingContinueButton(action: {
                viewModel.didTapFirstContinueButton()
            }, title: "Далее")
            
            OnboardingSkipButton(action: {
                viewModel.didTapSkipButton()
            })
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    OnboardingFirstView(viewModel: OnboardingViewModel())
}
