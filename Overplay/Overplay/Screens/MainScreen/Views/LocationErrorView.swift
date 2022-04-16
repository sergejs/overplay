//
//  LocationErrorView.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import Foundation
import SwiftUI

struct LocationErrorView: View {
    let error: LocationManagerError

    var body: some View {
        contentView
    }

    @ViewBuilder
    var contentView: some View {
        switch error {
        case .locationServicesNotAvailable:
            Text("Location services are not available.")
                .foregroundColor(.red)
                .font(.title2)
        case .accuracyIsLow:
            Text("GPS accuracy is too low.")
                .foregroundColor(.red)
                .font(.title2)
        case .notDetermined:
            EmptyView()
        }
    }
}
