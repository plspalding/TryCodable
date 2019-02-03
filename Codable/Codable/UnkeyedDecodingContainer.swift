//
//  UnkeyedDecodingContainer.swift
//  Codable
//
//  Created by Preston Spalding on 03/02/2019.
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

// Decode All
extension UnkeyedDecodingContainer {
    mutating func decode<T: Decodable, U>(
        all type: T.Type,
        map: (T) -> U?)
        -> Decode<[U]>
    {
        var array: [U] = []
        while !isAtEnd {
            do {
                guard let result = map(try decode(T.self))
                    else { return Decode<[U]>.failure("Failed to transform element at index: \(index)") }
                array.append(result)
            } catch {
                return Decode<[U]>.failure(error)
            }
        }
        return Decode.successful(array)
    }
    
    mutating func decode<T: Decodable>(
        all type: T.Type = T.self)
        -> Decode<[T]>
    {
        return decode(all: type, map: id)
    }
    
    mutating func decode<T: Decodable, U>(
        all type: T.Type = T.self,
        map: KeyPath<T, U?>)
        -> Decode<[U]>
    {
        return decode(all: type, map: ^map)
    }
}

// Decode Any
extension UnkeyedDecodingContainer {
    mutating func decode<T: Decodable, U>(
        any type: T.Type,
        map: (T) -> U?,
        log: ((Error) -> ())? = nil)
        -> Decode<[U]>
    {
        var array: [U?] = []
        while !isAtEnd {
            do {
                array.append(map(try decode(T.self)))
            } catch {
                log?(error)
                _ = try! decode(AnyCodable.self)
            }
        }
        return Decode.successful(array.compactMap(id))
    }
    
    mutating func decode<T: Decodable>(
        any type: T.Type = T.self)
        -> Decode<[T]>
    {
        return decode(any: type, map: id)
    }
    
    mutating func decode<T: Decodable, U>(
        _ type: T.Type = T.self,
        map: (T) -> U)
        -> Decode<[U]> {
        return decode(any: type, map: map)
    }
}
