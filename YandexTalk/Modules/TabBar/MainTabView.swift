//
//  MainTabView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ChatViewScreen()
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
    }
}
