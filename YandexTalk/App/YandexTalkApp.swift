//
//  YandexTalkApp.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 01.06.2025.
//

import SwiftUI

@main
struct YandexTalkApp: App {
    @AppStorage("hasCompletedOnboarding_v2") private var hasCompletedOnboarding: Bool = false
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingFlowView()
            }
        }
    }
}
