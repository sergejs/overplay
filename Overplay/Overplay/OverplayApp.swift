//
//  OverplayApp.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import SwiftUI

@main
struct OverplayApp: App {
    let viewModel = ContentViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
