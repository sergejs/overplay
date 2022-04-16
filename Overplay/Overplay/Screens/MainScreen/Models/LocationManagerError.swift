//
//  LocationManagerError.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import Foundation

enum LocationManagerError: Error {
    case locationServicesNotAvailable
    case accuracyIsLow
    case notDetermined
}
