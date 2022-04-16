//
//  ShakeManager.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import Combine
import Foundation
import UIKit

protocol ShakeManager {
    var publisher: CurrentValueSubject<Void, Never> { get }

    func start()
}

final class DeviceShakeManager: ShakeManager {
    private var disposeBag = Set<AnyCancellable>()
    let publisher = CurrentValueSubject<Void, Never>(())

    func start() {
        NotificationCenter.default
            .publisher(for: UIDevice.deviceDidShakeNotification)
            .map { _ in () }
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] in
                self?.publisher.send($0)
            })
            .store(in: &disposeBag)
    }
}
