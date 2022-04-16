//
//  ContentViewState.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import Foundation

enum ContentViewState {
    case initial
    case downloading(Double)
    case error(ContentViewError)
    case downloaded(PlayerViewModel)
}
