//
//  PlayerViewModel.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import AVKit
import Combine
import Foundation
import SwiftUI

final class PlayerViewModel: ObservableObject {
    private let contenPlayer: Player
    private let motionManager: MotionManager = GyroManager()
    private let shakeManager: ShakeManager = DeviceShakeManager()
    private let locationManager: LocationManager = TenMetersLocationManager()
    private var disposeBag = Set<AnyCancellable>()

    var player: AVPlayer { contenPlayer.player }

    @Published
    var volume: Float = 0
    @Published
    var angle: Double = 0
    @Published
    var scale: Double = 0
    @Published
    var locationError: LocationManagerError?
    @Published
    var contentViewError: ContentViewError?

    init(_ url: URL) {
        contenPlayer = ContenPlayer(url: url)
    }
}

extension PlayerViewModel {
    func onAppear() {
        contenPlayer.start()
        motionManager.start()
        shakeManager.start()
        locationManager.start()

        setupBindings()
    }
}

private extension PlayerViewModel {
    func setupBindings() {
        // While rotation along the x-axis should control the volume of the sound
        motionManager
            .publisher
            .map(\.roll)
            .map { Float($0 / 180) }
            .filter { $0 >= 0 }
            .handleEvents(
                receiveOutput: { [weak self] in
                    self?.volume = $0 * 100
                }
            )
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.contentViewError = error
                    }
                },
                receiveValue: contenPlayer.updateVolume(_:)
            )
            .store(in: &disposeBag)

        motionManager
            .publisher
            .replaceError(with: .zero)
            .map(\.pitch)
            .map { Double($0) }
            .assign(to: \.angle, on: self)
            .store(in: &disposeBag)

        motionManager
            .publisher
            .replaceError(with: .zero)
            .map(\.pitch)
            .map { max(1.0 - abs($0) / 90.0, 0.5) }
            .map { Double($0) }
            .assign(to: \.scale, on: self)
            .store(in: &disposeBag)

        // rotation along the z-axis should be able to control the current time where the video is playing.
        motionManager
            .publisher
            .replaceError(with: .zero)
            .map(\.pitch)
            .map { -($0 / 180) }
            .filter { $0 > 0.2 || $0 < -0.2 }
            .throttle(for: 0.5, scheduler: DispatchQueue.main, latest: true)
            .sink(receiveValue: contenPlayer.updateTime(_:))
            .store(in: &disposeBag)

        // A shake of the device should pause the video.
        shakeManager
            .publisher
            .dropFirst()
            .sink(receiveValue: contenPlayer.pauseOrPlay)
            .store(in: &disposeBag)

        // Using the user’s location, a change of 10 meters of the current and
        // previous location will reset the video and replay from the start.
        locationManager
            .publisher
            .sink(
                receiveValue: { [weak self] result in
                    switch result {
                    case .success:
                        self?.contenPlayer.reset()
                        self?.locationError = nil
                    case let .failure(error):
                        self?.locationError = error
                    }
                }
            )
            .store(in: &disposeBag)
    }
}
