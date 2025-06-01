//
//  OnboardingFlowView.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 01.06.2025.
//

import SwiftUI

struct OnboardingFlowView: View {
    @State private var navigationPath = NavigationPath()
    
    @StateObject private var viewModel = OnboardingViewModel()
    
    @AppStorage("hasCompletedOnboarding5") private var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            NavigationStack(path: $navigationPath) {
                OnboardingFirstView(viewModel: viewModel)
                    .navigationBarBackButtonHidden()
                
                    .navigationDestination(for: String.self) { value in
                        if value == "onboarding_second" {
                            OnboardingSecondView(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        } else if value == "onboarding_third" {
                            OnboardingThirdView(viewModel: viewModel)
                                .navigationBarBackButtonHidden()
                        }
                    }
            }
            
            .onChange(of: viewModel.requestedAction) { oldValue, newValue in
                guard let action = newValue else { return }
                
                switch action {
                case .didTapFirstContinue:
                    navigationPath.append("onboarding_second")
                case .didTapSecondContinue:
                    navigationPath.append("onboarding_third")
                case .didTapStart:
                    hasCompletedOnboarding = true
                    navigationPath = NavigationPath()
                case .didTapSkip:
                    hasCompletedOnboarding = true
                    navigationPath = NavigationPath()
                }
                
                viewModel.requestedAction = nil
            }
        }
    }
}
