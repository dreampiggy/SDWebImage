//
//  File.swift
//  
//
//  Created by lizhuoli on 2023/2/22.
//

import Foundation
import SDWebImageObjc

public enum ContextOption {
    case retryFailed
    case storeCache(SDImageCache)
}
public typealias ContextOptions = [ContextOption]

extension ContextOptions {
    public func bridgeToObjectiveC() -> SDWebImageOptionsResult {
        var options: SDWebImageOptions = []
        var context: [SDWebImageContextOption : Any] = [:]
        self.forEach { contextOption in
            switch contextOption {
            case .retryFailed: options.insert(.retryFailed)
            case .storeCache(let cache): context[.storeCacheType] = cache
            }
        }
        return SDWebImageOptionsResult(options: options, context: context.isEmpty ? nil : context)
    }

    public static func bridgeFromObjectiveC(source: SDWebImageOptionsResult, result: inout ContextOptions) {
        switch source.options {
        case .retryFailed: result.append(.retryFailed)
        default:
            fatalError("TODO")
        }
        source.context?.forEach { key, value in
            switch key {
            case .storeCacheType: result.append(.storeCache(value as! SDImageCache))
            default:
                fatalError("TODO")
            }
        }
    }
}
