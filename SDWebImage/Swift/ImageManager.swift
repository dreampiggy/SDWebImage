//
//  File.swift
//  
//
//  Created by lizhuoli on 2023/2/22.
//

import Foundation
@_exported import SDWebImageObjc

extension SDWebImageManager {
    @available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
    public func loadImage(with url: URL?, contextOptions: [ContextOption] = [], progressBlock: LoaderProgressBlock? = nil) async throws -> LoadImageResult {
        let optionsResult = contextOptions.bridgeToObjectiveC()
        
        return try await withCheckedThrowingContinuation { co in
            self.loadImage(with: url, options: optionsResult.options, context: optionsResult.context, progress: progressBlock) { image, data, error, cacheType, finished, url in
                var result: Result<LoadImageResult, Error>
                if let error = error {
                    result = .failure(error)
                } else if let image = image, let url = url {
                    let imageResult = LoadImageResult(image: image, data: data, cacheType: cacheType, url: url)
                    result = .success(imageResult)
                } else {
                    result = .failure(NSError())
                }
                co.resume(with: result)
            }
        }
    }
    
    
    public var optionsProcessor: ((URL?, ContextOptions) -> ContextOptions)? {
        get {
            guard let optionsProcessor = __optionsProcessor else { return nil }
            return { url, contextOptions in
                let optionsResult = contextOptions.bridgeToObjectiveC()
                if let newOptionsResult = optionsProcessor.processedResult(for: url, options: optionsResult.options, context: optionsResult.context) {
                    var contextOptions: ContextOptions = []
                    ContextOptions.bridgeFromObjectiveC(source: SDWebImageOptionsResult(options: newOptionsResult.options, context: newOptionsResult.context), result: &contextOptions)
                    return contextOptions
                } else {
                    return []
                }
            }
        }
        set {
            guard let newValue = newValue else {
                __optionsProcessor = nil
                return
            }
            __optionsProcessor = SDWebImageOptionsProcessor { url, options, context in
                var contextOptions: ContextOptions = []
                ContextOptions.bridgeFromObjectiveC(source: SDWebImageOptionsResult(options: options, context: context), result: &contextOptions)
                let newContextOptions = newValue(url, contextOptions)
                return newContextOptions.bridgeToObjectiveC()
            }
        }
    }
}
