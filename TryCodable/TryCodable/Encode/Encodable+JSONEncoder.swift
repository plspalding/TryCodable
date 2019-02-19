//
//  JSONEncoder.swift
//  TryCodable
//
//  Created by Preston Spalding on 17/02/2019.
//  Copyright © 2019 Preston Spalding. All rights reserved.
//

import Foundation

extension Encodable {
    
    public func encode(jsonEncoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try jsonEncoder.encode(self)
    }
}
