/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

import Foundation

/// Wrapper for SDWebImage compatible types. This type provides an extension point for
/// connivence methods in SDWebImage.
public struct SDWebImageWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// Represents an object type that is compatible with SDWebImage. You can use `sd` property to get a
/// value in the namespace of SDWebImage.
public protocol SDWebImageCompatible: AnyObject {}

/// Represents a value type that is compatible with SDWebImage. You can use `sd` property to get a
/// value in the namespace of SDWebImage.
public protocol SDWebImageCompatibleValue {}

extension SDWebImageCompatible {
    /// Gets a namespace holder for SDWebImage compatible types.
    public var sd: SDWebImageWrapper<Self> {
        get {
            return SDWebImageWrapper(self)
        }
        set {}
    }
    
    /// Gets a namespace holder for SDWebImage compatible meta types.
    public static var sd: SDWebImageWrapper<Self>.Type {
        get {
            return SDWebImageWrapper.self
        }
        set {}
    }
}

extension SDWebImageCompatibleValue {
    /// Gets a namespace holder for SDWebImage compatible types.
    public var sd: SDWebImageWrapper<Self> {
        get {
            return SDWebImageWrapper(self)
        }
        set {}
    }
    
    /// Gets a namespace holder for SDWebImage compatible meta types.
    public static var sd: SDWebImageWrapper<Self>.Type {
        get {
            return SDWebImageWrapper.self
        }
        set {}
    }
}
