//
//  LocationManager.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import Combine
import CoreLocation
import Foundation

protocol LocationManager {
    typealias LocationManagerResult = Result<Void, LocationManagerError>
    var publisher: CurrentValueSubject<LocationManagerResult, Never> { get }
    func start()
}

final class TenMetersLocationManager: NSObject, LocationManager {
    private var disposeBag = Set<AnyCancellable>()
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 10
        locationManager.activityType = .fitness

        return locationManager
    }()

    private var lastLocation: CLLocation?

    let publisher = CurrentValueSubject<Result<Void, LocationManagerError>, Never>(.failure(.notDetermined))

    func start() {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension TenMetersLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            publisher.send(.failure(.locationServicesNotAvailable))
        case .notDetermined:
            publisher.send(.failure(.notDetermined))
        case .restricted:
            publisher.send(.failure(.locationServicesNotAvailable))
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard
            let location = locations.last,
            location.horizontalAccuracy <= 10
        else {
            publisher.send(.failure(.accuracyIsLow))
            return
        }

        if let lastLocation = lastLocation, location.distance(from: lastLocation) >= 10 {
            publisher.send(.success(()))
        }

        lastLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            locationManager.stopMonitoringSignificantLocationChanges()
            publisher.send(.failure(.locationServicesNotAvailable))
        }
    }
}
