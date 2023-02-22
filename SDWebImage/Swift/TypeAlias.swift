//
//  File.swift
//  
//
//  Created by lizhuoli on 2023/2/22.
//

import Foundation
@_exported import SDWebImageObjc

// Alias and remove all SD prefix.
// Or totally rename using `NS_SWIFT_NAME` ?
//public typealias ImageCache = SDImageCache
//public extension ImageCache {
//    typealias Config = SDImageCacheConfig
//    typealias Token = SDImageCacheToken
//}

public typealias LoaderProgressBlock = (Int, Int, URL?) -> Void
public typealias LoaderCompletedBlock = (PlatformImage?, Data?, Error?, Bool) -> Void
