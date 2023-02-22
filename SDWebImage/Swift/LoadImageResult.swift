//
//  File.swift
//  
//
//  Created by lizhuoli on 2023/2/22.
//

import Foundation

public struct LoadImageResult {
    public var url: URL
    public var image: PlatformImage
    public var data: Data?
    public var cacheType: SDImageCacheType
}
