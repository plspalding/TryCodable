//
//  Decode.swift
//  Codable
//
//  Created by Preston Spalding on 31/01/2019.
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

extension String: Error { }

prefix operator ^

prefix func ^<A, B>(_ keyPath: KeyPath<A, B>) -> (A) -> B {
    return { a in
        a[keyPath: keyPath]
    }
}

func id<A>(_ value: A) -> A {
    return value
}

struct AnyCodable: Codable {}

enum Decode<T: Decodable, K: CodingKey> {
    case Successful(T)
    case Failure(Error)
    init(f: (T.Type, KeyedDecodingContainer<K>.Key) throws -> T, key: K) {
        do {
            self = .Successful(try f(T.self, key))
        } catch {
            self = .Failure(error)
        }
    }
    
    func valueOrThrow(
        file: String = #file,
        function: String = #function,
        line: Int = #line)
        throws -> T {
            // TODO: Use file, function and line to create a lovely error
            switch self {
            case .Successful(let value): return value
            case .Failure(let error): throw error
            }
    }
    
    func valueOrNil() -> T? {
        switch self {
        case .Successful(let value): return value
        case .Failure(_): return nil
        }
    }
    
    func valueElse(_ defaultValue: @autoclosure () -> T) -> T {
        switch self {
        case .Successful(let value): return value
        case .Failure(_): return defaultValue()
        }
    }
}

enum DecodeArray<T> {
    case Successful([T])
    case Failure(Error)
    
    init(f: ([T].Type) throws -> [T]) {
        do {
            self = .Successful(try f([T].self))
        } catch {
            self = .Failure(error)
        }
    }
    
    func valueOrThrow(
        file: String = #file,
        function: String = #function,
        line: Int = #line)
        throws -> [T] {
            switch self {
            case .Successful(let value): return value
            case .Failure(let error): throw error
            }
    }
    
    func valueOrNil() -> [T]? {
        switch self {
        case .Successful(let value): return value
        case .Failure(_): return nil
        }
    }
    
    func valueElse(_ defaultValue: @autoclosure () -> [T]) -> [T] {
        switch self {
        case .Successful(let value): return value
        case .Failure(_): return defaultValue()
        }
    }
}


extension KeyedDecodingContainer {
    
    func decode<T: Decodable>(_ key: Key) -> Decode<T, Key> {
        return Decode(f: { (a, b) -> T in
            try decode(a.self, forKey: b)
        }, key: key)
    }
    
    func decode<T: Decodable, U>(_ key: Key, map: (T) -> U?) -> Decode<U, Key> {
        return Decode(f: { (a, b) throws -> U in
            let result = map(try decode(T.self, forKey: b))
            if  result == nil {
                throw "Failed to transform data"
            } else {
                return result!
            }
        }, key: key)
    }
    
    func decode<T: Decodable, U>(_ key: Key, map: KeyPath<T, U>) -> Decode<U, Key> {
        return decode(key, map: ^map)
    }
    
    func decodeAny<T: Decodable>(_ type: T.Type, _ key: Key) -> DecodeArray<T> {
        return DecodeArray(f: { (a) throws -> [T] in
            
            var unkeyedContainer = try nestedUnkeyedContainer(forKey: key)
            return unkeyedContainer._decodeAny(type)
        })
    }
}

extension UnkeyedDecodingContainer {
    mutating func _decodeAny<T: Decodable>(_ type: T.Type) -> [T] {
        var array: [T?] = []
        while !isAtEnd {
            do {
                array.append(try decode(T.self))
            } catch {
                try! decode(AnyCodable.self)
            }
        }
        return array.compactMap(id)
    }
    
    mutating func decodeAny<T: Decodable>(_ type: T.Type) -> DecodeArray<T> {
        return DecodeArray(f: { (a) throws -> [T] in
            return _decodeAny(type)
        })
    }
}


struct Person {
    let name: String
    let age: Int?
    let street: String
    let county: String
    let favNumber: Int?
}

extension Person: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(.name).valueOrThrow()
        age = container.decode(.age).valueOrNil()
        street = try container.decode(.street, map: { (s: String) in s.uppercased() }).valueOrThrow()
        county = "West Yorkshire hardcoded"
        favNumber = container.decode(.favNumber, map: { (s: String) in Int(s) }).valueElse(10)
    }
    
    enum CodingKeys: CodingKey {
        case name
        case age
        case street
        case county
        case favNumber
    }
}
