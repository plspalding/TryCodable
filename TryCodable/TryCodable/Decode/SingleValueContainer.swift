//
//  SingleValueContainer.swift
//  TryCodable
//
//  Created by Preston Spalding on 05/02/2019.
//  Copyright © 2019 Preston Spalding.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

extension SingleValueDecodingContainer {
    
    public func decode<T: Decodable, U>(
        map: (T) -> U?)
        -> TryCodable<U>
    {
        return TryCodable {
            guard let result = map(try decode(T.self)) else {
                throw singleTransformError(container: self)
            }
            return result
        }
    }
    
    public func decode<T: Decodable>() -> TryCodable<T>
    {
        return decode(map: id)
    }
    
    public func decode<T: Decodable, U>(
        map: KeyPath<T, U>)
        -> TryCodable<U>
    {
        return decode(map: ^map)
    }
    
    public func decode<T: Decodable, U>(
        map: KeyPath<T, U?>)
        -> TryCodable<U>
    {
        return decode(map: ^map)
    }
}
