//
//  AttitudePercentage.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import UIKit

struct AttitudePercentage {
    let roll: Double
    let pitch: Double
    let yaw: Double

    static var zero = AttitudePercentage(roll: 0, pitch: 0, yaw: 0)
}
