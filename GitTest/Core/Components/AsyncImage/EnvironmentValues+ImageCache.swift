//
//  EnvironmentValues+ImageCache.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 08/07/2021.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    
    static let defaultValue: ImageCache = TemporaryImageCache()
    
}

extension EnvironmentValues {
    
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
    
}
