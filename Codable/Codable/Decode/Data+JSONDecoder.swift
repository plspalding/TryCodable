//
//  JSONDecoder.swift
//  Codable
//
//  Created by Preston Spalding on 17/02/2019.
//  Copyright © 2019 Preston Spalding. All rights reserved.
//

import Foundation

extension Data {
    
    public func decode<T: Decodable>(
        as type: T.Type,
        jsonDecoder: JSONDecoder = JSONDecoder())
        throws -> TryCodable<T>
    {
        return TryCodable { try jsonDecoder.decode(T.self, from: self) }
    }
}
