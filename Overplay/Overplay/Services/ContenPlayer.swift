//
//  ContenPlayer.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import AVKit
import Foundation

protocol Player {
    var player: AVPlayer { get }
    func updateVolume(_ volume: Float)
    func updateTime(_ time: Float64)
    func reset()
    func start()
    func pauseOrPlay()
}

final class ContenPlayer: Player {
    let player: AVPlayer

    init(url: URL) {
        player = AVPlayer(url: url)
    }

    func updateVolume(_ volume: Float) {
        player.volume = volume
    }

    func updateTime(_ time: Float64) {
        let time = time * 5
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime + time

        if newTime < 0 {
            newTime = .zero
        }

        guard
            let duration = player.currentItem?.duration,
            newTime < CMTimeGetSeconds(duration)
        else {
            return
        }

        let result = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player.seek(
            to: result,
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
    }

    func reset() {
        player.seek(to: .zero)
        start()
    }

    func start() {
        player.playImmediately(atRate: 1)
    }

    func pauseOrPlay() {
        if player.rate != 0, player.error == nil {
            player.pause()
        } else {
            player.play()
        }
    }
}
