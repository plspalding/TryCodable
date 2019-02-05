//
//  KeyedDecodingContainer.swift
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

// MARK:- Standard API
extension KeyedDecodingContainer {
    
    public func decode<T: Decodable, U>(
        _ key: Key,
        map: (T) -> U?)
        -> Decode<U>
    {
        return Decode {
            guard let result = map(try decode(T.self, forKey: key)) else {
                throw keyedTransformError(key: key, container: self, codingPath: codingPath)
            }
            return result
        }
    }
    
    public func decode<T: Decodable>(_ key: Key) -> Decode<T> {
        return decode(key, map: id)
    }
}

// MARK:- All API
extension KeyedDecodingContainer {
    
    public func decode<T: Decodable>(
        all type: T.Type = T.self,
        _ key: Key,
        log: Logger = .inactive)
        -> Decode<[T]>
    {
        do {
            var unkeyedContainer = try nestedUnkeyedContainer(forKey: key)
            return unkeyedContainer.decode(all: type, map: id)
        } catch {
            return Decode<[T]>.failure(error)
        }
    }
    
    public func decode<T: Decodable, U>(
        all type: T.Type = T.self,
        _ key: Key,
        map: @escaping (T) -> U?,
        log: Logger = .inactive)
        -> Decode<[U]>
    {
        do {
            var unkeyedContainer = try nestedUnkeyedContainer(forKey: key)
            return unkeyedContainer.decode(all: type, map: map)
        } catch {
            return Decode<[U]>.failure(error)
        }
    }
}

// MARK:- Any API
extension KeyedDecodingContainer {
    public func decode<T: Decodable>(
        any type: T.Type,
        _ key: Key,
        log: Logger = .inactive)
        -> Decode<[T]>
    {
        do {
            var unkeyedContainer = try nestedUnkeyedContainer(forKey: key)
            return unkeyedContainer.decode(any: type, map: id, log: log)
        } catch {
            return Decode<[T]>.failure(error)
        }
    }
    
    public func decode<T: Decodable, U>(
        any type: T.Type,
        _ key: Key,
        map: @escaping (T) -> U?,
        log: Logger = .inactive)
        -> Decode<[U]>
    {
        do {
            var unkeyedContainer = try nestedUnkeyedContainer(forKey: key)
            return unkeyedContainer.decode(any: type, map: map, log: log)
        } catch {
            return Decode<[U]>.failure(error)
        }
    }
}

// MARK:- KeyPath API
extension KeyedDecodingContainer {
    public func decode<T: Decodable, U>(
        _ key: Key,
        map: KeyPath<T, U?>)
        -> Decode<U>
    {
        return decode(key, map: ^map)
    }
}
