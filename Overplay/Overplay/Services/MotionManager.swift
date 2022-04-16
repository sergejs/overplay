//
//  MotionManager.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import Combine
import CoreMotion
import Foundation

protocol MotionManager {
    var publisher: CurrentValueSubject<AttitudePercentage, ContentViewError> { get }

    func start()
}

final class GyroManager: MotionManager {
    private static let fps = 60.0
    private let manager = CMMotionManager()
    let publisher = CurrentValueSubject<AttitudePercentage, ContentViewError>(.zero)

    func start() {
        guard
            manager.isDeviceMotionAvailable
        else {
            publisher.send(completion: .failure(.gyroNotAvailabale))
            return
        }

        manager.deviceMotionUpdateInterval = 1.0 / Self.fps
        manager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            guard
                error == nil,
                let attitude: CMAttitude = data?.attitude
            else {
                self?.publisher.send(completion: .failure(.gyroNotAvailabale))
                return
            }

            let roll = attitude.roll * 180 / .pi
            let pitch = attitude.pitch * 180 / .pi
            let yaw = attitude.yaw * 180 / .pi

            let attitudePercentage = AttitudePercentage(
                roll: roll,
                pitch: pitch,
                yaw: yaw
            )

            self?.publisher.send(attitudePercentage)
        }
    }
}
