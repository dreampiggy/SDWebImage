//
//  File.swift
//  
//
//  Created by lizhuoli on 2023/2/22.
//

import Foundation

public struct LoadImageResult {
    public var image: PlatformImage
    public var data: Data?
    public var cacheType: SDImageCacheType
    public var url: URL
}
