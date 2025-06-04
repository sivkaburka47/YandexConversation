//
//  SettingsScreenView.swift
//  YandexTalk
//
//  Created by Станислав Дейнекин on 01.06.2025.
//

import SwiftUI

struct SettingsScreenView: View {
    var body: some View {
        VStack {
            Image("yandexLogo")
                .accessibilityLabel("Логотип Яндекс")
            Text("В разработке...")
                .multilineTextAlignment(.center)
                .foregroundColor(Color("korich"))
                .font(.system(size: 32, weight: .medium))
                .padding(.horizontal)
                .accessibilityLabel("Раздел настроек в разработке")
        }
    }
}
