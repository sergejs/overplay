//
//  PlayerView.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import Foundation
import SwiftUI

struct PlayerView: View {
    @ObservedObject
    var viewModel: PlayerViewModel

    var body: some View {
        ZStack {
            AVPlayerControllerRepresented(player: viewModel.player)
            VStack {
                HStack(spacing: 4) {
                    ForEach(0 ... Int(viewModel.volume / 3), id: \.self) { _ in
                        BarView()
                            .opacity(0.7)
                            .transition(.asymmetric(insertion: .scale, removal: .opacity))
                            .animation(.easeInOut, value: 1)
                    }
                    Spacer()
                }
                .padding(.all, 8)

                Spacer()

                if let error = viewModel.locationError {
                    LocationErrorView(error: error)
                }
                if let error = viewModel.contentViewError {
                    ErrorView(error: error)
                }
            }
        }
        .rotationEffect(.degrees(viewModel.angle))
        .animation(.easeInOut, value: viewModel.angle)
        .scaleEffect(viewModel.scale)
        .animation(.easeInOut, value: viewModel.scale)
        .onAppear(perform: viewModel.onAppear)
    }
}
