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

    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView(selection: $selectedTab) {
                ChatViewScreen(navigationPath: $navigationPath)
                    .padding(.bottom, 16)
                    .tabItem {
                        Image(selectedTab == 0 ? "leftTabIconActive" : "leftTabIconUnactive")
                    }
                    .tag(0)

                PhrasesScreenView()
                    .tabItem {
                        Image(selectedTab == 1 ? "secTabIconActive" : "secTabIconUnactive")
                    }
                    .tag(1)

                SettingsScreenView()
                    .tabItem {
                        Image(selectedTab == 2 ? "rightTabIconActive" : "rightTabIconUnactive")
                    }
                    .tag(2)
            }
            .navigationDestination(for: String.self) { value in
                if value == "microphone" {
                    MicrophoneScreen()
                }
            }
        }
    }
}
