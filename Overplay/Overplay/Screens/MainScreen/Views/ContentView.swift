//
//  ContentView.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject
    var viewModel: ContentViewModel

    var body: some View {
        contentView
            .onAppear(perform: viewModel.onAppear)
    }

    @ViewBuilder
    var contentView: some View {
        switch viewModel.state {
        case .initial:
            EmptyView()
        case let .downloading(progress):
            Text("Downloading \(progress * 100, specifier: "%.2f")")
        case let .error(error):
            ErrorView(error: error)
        case let .downloaded(viewModel):
            PlayerView(viewModel: viewModel)
        }
    }
}
