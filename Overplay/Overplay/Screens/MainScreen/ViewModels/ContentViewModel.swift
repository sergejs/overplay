//
//  ContentViewModel.swift
//  Overplay
//
//  Created by Sergejs Smirnovs on 16.04.22.
//

import Alamofire
import Combine
import Foundation
import SwiftUI

final class ContentViewModel: ObservableObject {
    private static let fileURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4"
    private var playerViewModel: PlayerViewModel?

    @Published
    var state: ContentViewState = .initial
}

private extension ContentViewModel {
    // Loads and plays a video file after launch.
    func startDownloading() async {
        do {
            await updateState(.downloading(0))
            let destination = DownloadRequest.suggestedDownloadDestination(
                for: .documentDirectory,
                options: [
                    .createIntermediateDirectories,
                    .removePreviousFile,
                ]
            )
            let task = AF.download(Self.fileURL, to: destination)

            task.downloadProgress { progress in
                Task {
                    await self.updateState(.downloading(progress.fractionCompleted))
                }
            }

            let url = try await task.serializingDownloadedFileURL().value
            let playerViewModel = PlayerViewModel(url)
            await updateState(.downloaded(playerViewModel))
        } catch {
            await updateState(.error(.failedToDownload))
        }
    }

    @MainActor
    func updateState(_ state: ContentViewState) {
        self.state = state
    }
}

extension ContentViewModel {
    func onAppear() {
        Task {
            await startDownloading()
        }
    }
}
