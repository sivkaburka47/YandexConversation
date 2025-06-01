//
//  FontModificators.swift
//  YandexTalk
//
//  Created by Богдан Тарченко on 01.06.2025.
//

import SwiftUI

// MARK: - Font
extension Font {

    static let onboardTitle = Font.system(size: 32, weight: .black)
    static let textBody = Font.system(size: 20, weight: .regular)
    static let bodyMedium = Font.system(size: 20, weight: .medium)
}

// MARK: - View Modifiers
extension View {
    func onboardTitleStyle() -> some View {
        self.font(.onboardTitle)
    }
    
    func textBodyStyle() -> some View {
        self.font(.textBody)
    }
    
    func bodyMediumStyle() -> some View {
        self.font(.bodyMedium)
    }
}
