//
//  MainTabView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var navigationPath = NavigationPath()
    @State private var showMicrophoneScreen = false
    @State private var microphoneText: String = ""

    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView(selection: $selectedTab) {
                ChatViewScreen(
                    navigationPath: $navigationPath,
                    showMicrophoneScreen: $showMicrophoneScreen,
                    microphoneText: $microphoneText
                )
                    .padding(.bottom, 16)
                    .tabItem {
                        Image(selectedTab == 0 ? "leftTabIconActive" : "leftTabIconUnactive")
                            .accessibilityLabel("Чат")
                    }
                    .tag(0)

                PhrasesScreenView(
                    showMicrophoneScreen: $showMicrophoneScreen,
                    microphoneText: $microphoneText
                )
                    .tabItem {
                        Image(selectedTab == 1 ? "secTabIconActive" : "secTabIconUnactive")
                            .accessibilityLabel("Фразы")
                    }
                    .tag(1)

                SettingsScreenView()
                    .tabItem {
                        Image(selectedTab == 2 ? "rightTabIconActive" : "rightTabIconUnactive")
                            .accessibilityLabel("Настройки")
                    }
                    .tag(2)
            }
            .fullScreenCover(isPresented: $showMicrophoneScreen) {
                MicrophoneScreen(messageText: microphoneText)
            }
        }
    }
}
