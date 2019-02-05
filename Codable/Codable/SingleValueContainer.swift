//
//  SingleValueContainer.swift
//  Codable
//
//  Created by Preston Spalding on 05/02/2019.
//  Copyright © 2019 Preston Spalding. All rights reserved.
//

import Foundation

extension SingleValueDecodingContainer {
    
    func decode<T: Decodable>() -> Decode<T>
    {
        return Decode {
            return try decode(T.self)
        }
    }
    
    func decode<T: Decodable, U>(
        map: (T) -> U?)
        -> Decode<U>
    {
        return Decode {
            guard let result = map(try decode(T.self)) else {
                throw singleTransformError(container: self)
            }
            return result
        }
    }
}
