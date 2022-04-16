//
//  BarView.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import Foundation
import SwiftUI

struct BarView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 20, height: 10)
        }
    }
}
