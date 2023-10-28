//
//  ImageLoader.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 08/07/2021.
//

import Combine
import SwiftUI

final class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL?
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(urlString: String, cache: ImageCache? = nil) {
        url = URL(string: urlString)
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        guard let url = url else {
            return image = UIImage(systemName: "questionmark.circle")
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0, forKey: url) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

extension ImageLoader {
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?, forKey key: URL) {
        image.map { cache?[key] = $0 }
    }
    
}
