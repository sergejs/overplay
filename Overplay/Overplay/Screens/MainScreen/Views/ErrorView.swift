//
//  ErrorView.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    let error: ContentViewError

    var body: some View {
        contentView
    }

    @ViewBuilder
    var contentView: some View {
        switch error {
        case .gyroNotAvailabale:
            Text("Gyroscope is not available.")
                .foregroundColor(.red)
                .font(.title2)
        case .failedToDownload:
            Text("Unable to download file.")
                .foregroundColor(.red)
                .font(.title2)
        }
    }
}
