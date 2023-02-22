//
//  File.swift
//  
//
//  Created by lizhuoli on 2023/2/22.
//

import Foundation

public typealias LoaderProgressBlock = (Int, Int, URL?) -> Void
public typealias LoaderCompletedBlock = (PlatformImage?, Data?, Error?, Bool) -> Void
