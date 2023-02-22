//
//  File.swift
//  
//
//  Created by lizhuoli on 2023/2/22.
//

import Foundation

#if canImport(SwiftUI)
import SwiftUI
#endif
#if os(macOS)
import AppKit
#endif
#if os(iOS) || os(tvOS)
import UIKit
#endif
#if os(watchOS)
import WatchKit
#endif

#if os(macOS)
public typealias PlatformImage = NSImage
#else
public typealias PlatformImage = UIImage
#endif

#if os(macOS)
public typealias PlatformView = NSView
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformView = UIView
#endif
#if os(watchOS)
public typealias PlatformView = WKInterfaceObject
#endif

#if os(macOS)
public typealias PlatformImageView = NSImageView
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformImageView = UIImageView
#endif


/// SwiftUI

#if os(macOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public typealias PlatformViewRepresentable = NSViewRepresentable
#endif
#if os(iOS) || os(tvOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public typealias PlatformViewRepresentable = UIViewRepresentable
#endif
#if os(watchOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public typealias PlatformViewRepresentable = WKInterfaceObjectRepresentable
#endif

#if os(macOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension NSViewRepresentable {
    typealias PlatformViewType = NSViewType
}
#endif
#if os(iOS) || os(tvOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension UIViewRepresentable {
    typealias PlatformViewType = UIViewType
}
#endif
#if os(watchOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension WKInterfaceObjectRepresentable {
    typealias PlatformViewType = WKInterfaceObjectType
}
#endif
