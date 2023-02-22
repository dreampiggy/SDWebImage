//
//  File.swift
//  
//
//  Created by lizhuoli on 2023/2/22.
//

import Foundation
@_exported import SDWebImageObjc

public enum QueueAttriutes {
    case serial(DispatchQoS = .default, DispatchQueue.AutoreleaseFrequency = .inherit)
    case concurrent(DispatchQoS = .default, DispatchQueue.AutoreleaseFrequency = .inherit)
    
    public func bridgeToObjectiveC() -> __OS_dispatch_queue_attr {
        let attr: __OS_dispatch_queue_attr
        switch self {
        case .serial(let qos, let af):
            attr = SDCreateDispatchQueueAttributes(false, qos.qosClass.rawValue, Int32(qos.relativePriority), convertAutoreleaseFrequency(af))
        case .concurrent(let qos, let af):
            attr = SDCreateDispatchQueueAttributes(true, qos.qosClass.rawValue, Int32(qos.relativePriority), convertAutoreleaseFrequency(af))
        }
        return attr
    }
    private func convertAutoreleaseFrequency(_ af: DispatchQueue.AutoreleaseFrequency) -> __dispatch_autorelease_frequency_t {
        switch af {
        case .inherit: return .init(rawValue: 0)!
        case .workItem: return .init(rawValue: 1)!
        case .never: return .init(rawValue: 2)!
        default: fatalError()
        }
    }
}
