//
//  AVPlayerControllerRepresented.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import AVKit
import Foundation
import SwiftUI

struct AVPlayerControllerRepresented: UIViewControllerRepresentable {
    var player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
