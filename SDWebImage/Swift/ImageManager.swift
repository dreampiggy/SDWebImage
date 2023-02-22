//
//  File.swift
//  
//
//  Created by lizhuoli on 2023/2/22.
//

import Foundation
import SDWebImageObjc

extension SDWebImageManager {
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
