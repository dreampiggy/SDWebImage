//
//  File.swift
//  
//
//  Created by lizhuoli on 2023/2/22.
//

#if !os(watchOS)

#if os(macOS)
import AppKit
#else
import UIKit
#endif

import SDWebImageObjc

extension UIImageView : SDWebImageCompatible {}
extension SDWebImageWrapper where Base : UIImageView {
    public func testOnlyCurrentModule(with url: URL?,
                          placeholder: PlatformImage? = nil,
                          progressBlock: LoaderProgressBlock? = nil,
                          completionBlock: ((Result<LoadImageResult, Error>) -> Void)? = nil) {
    }
    
    public func testSubmoduleType(with url: URL?,
                          placeholder: PlatformImage? = nil,
                          contextOptions: SDImageCoderHelper? = nil, // from SDWebImage dependency module
                          progressBlock: LoaderProgressBlock? = nil,
                          completionBlock: ((Result<LoadImageResult, Error>) -> Void)? = nil) {
    }
    
    
    public func setImage(with url: URL?,
                         placeholder: PlatformImage? = nil,
                         contextOptions: [ContextOption] = [], // from SDWebImageSwift, but enum case need SDWebImage dependency module
                         progressBlock: LoaderProgressBlock? = nil,
                         completionBlock: ((Result<LoadImageResult, Error>) -> Void)? = nil) {
//        let optionsResult = contextOptions.bridgeToObjectiveC()
//
//        base.sd_internalSetImage(with: url, placeholderImage: placeholder, options:optionsResult.options, context:optionsResult.context, setImageBlock: nil, progress: progressBlock) { image, data, error, cacheType, finished, url in
//            var result: Result<LoadImageResult, Error>
//            if let error = error {
//                result = .failure(error)
//            } else if let image = image {
//                let imageResult = LoadImageResult(image: image, data: data, extendedObject: image.sd_extendedObject)
//                result = .success(imageResult)
//            } else {
//                result = .failure(NSError())
//            }
//            completionBlock?(result)
//        }
//        return SDWebImageCombinedOperation()
    }
}

#endif
