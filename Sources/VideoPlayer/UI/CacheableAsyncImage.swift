//
//  File.swift
//  VideoPlayer
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import Foundation
import SwiftUI
import Combine

public struct CacheableAsyncImage<Content: View>: View {
    @State var phase: AsyncImagePhase = .empty
    
    private let cache: ImageCacheable
    private let url: URL
    private var transaction: Transaction
    @ViewBuilder private var content: (AsyncImagePhase) -> Content
    
    public init(
        url: URL,
        cache: ImageCacheable = SimpleImageCache.shared,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.cache = cache
        self.transaction = transaction
        self.content = content
    }
    
    public var body: some View {
        content(phase)
            .transaction { view in
                view.animation = self.transaction.animation
            }
            .task {
                for await phase in cache.load(url: url).values {
                    self.phase = phase
                }
            }
    }
}

public protocol ImageCacheable {
    func load(url: URL) -> AnyPublisher<AsyncImagePhase, Never>
}

public class SimpleImageCache: ImageCacheable, @unchecked Sendable {
    enum Error: Swift.Error {
        case imageDecodingFailed
    }
    
    public static let shared = SimpleImageCache()
    var loaders: [URL: (publisher: AnyPublisher<AsyncImagePhase, Never>, cancellable: AnyCancellable)] = [:]
    
    public func load(url: URL) -> AnyPublisher<AsyncImagePhase, Never> {
        if let (publisher, _) = loaders[url] {
            return publisher
        } else {
            let subject = CurrentValueSubject<AsyncImagePhase, Never>(.empty)
            let publisher = subject.eraseToAnyPublisher()
            let cancellable = URLSession
                .shared.dataTaskPublisher(for: url)
                .map({ (data, _) in
                    if let image = UIImage(data: data) {
                        return AsyncImagePhase.success(Image(uiImage: image))
                    } else {
                        return .failure(Error.imageDecodingFailed)
                    }
                })
                .catch { Just<AsyncImagePhase>(AsyncImagePhase.failure($0)) }
                .handleEvents(receiveOutput: subject.send)
                .sink(receiveValue: { [weak self] _ in
                    self?.loaders[url]?.cancellable.cancel()
                    self?.loaders[url] = nil
                })
            
            loaders[url] = (publisher: publisher, cancellable: cancellable)
            return publisher
        }
    }
}
