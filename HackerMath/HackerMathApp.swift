//
//  HackerMathApp.swift
//  HackerMath
//
//  Created by Taylor Tran on 11/9/24.
//

import SwiftUI

@main
struct HackerMathApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WelcomeView()
            }
            .environmentObject(
                GameViewModel(
                    difficulty: 1,
                    questionCount: 10
                )
            )
        }
    }
}
