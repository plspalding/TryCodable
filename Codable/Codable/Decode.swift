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

extension String: Error { }

// TODO: Being Decodable does not work. But will this cause any other problems?? I dont' think so.
enum Decode<T> {
    case Successful(T)
    case Failure(Error)
    init(f: () throws -> T) {
        do {
            self = .Successful(try f())
        } catch {
            self = .Failure(error)
        }
    }
    
    enum CodingKeys: CodingKey { case empty }
    static var emptyKey: CodingKey {
        
        return CodingKeys.empty
    }
    
    func valueOrThrow(
        file: String = #file,
        function: String = #function,
        line: Int = #line)
        throws -> T {
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

extension KeyedDecodingContainer {
    
    func decode<T: Decodable>(_ key: Key) -> Decode<T> {
        return Decode(f: { () -> T in
            try decode(T.self, forKey: key)
        })
    }
    
    func decode<T: Decodable, U>(_ key: Key, map: (T) -> U?) -> Decode<U> {
        return Decode(f: { () throws -> U in
            let result = map(try decode(T.self, forKey: key))
            if  result == nil {
                throw "Failed to transform data"
            } else {
                return result!
            }
        })
    }
    
    func decode<T: Decodable, U>(_ key: Key, map: KeyPath<T, U?>) -> Decode<U> {
        return decode(key, map: ^map)
    }
    
    func decodeAny<T: Decodable>(_ type: T.Type, _ key: Key) -> Decode<[T]> {
        return Decode(f: { () throws -> [T] in
            
            var unkeyedContainer = try nestedUnkeyedContainer(forKey: key)
            return unkeyedContainer._decodeAny(type, map: id)
        })
    }
    
    //    func decodeAny<T: Decodable>(_ type: T.Type, _ key: Key) -> DecodeArray<T> {
    //        return DecodeArray(f: { (a) throws -> [T] in
    //
    //            var unkeyedContainer = try nestedUnkeyedContainer(forKey: key)
    //            return unkeyedContainer._decodeAny(type, map: id)
    //        })
    //    }
    
    func decodeAny<T: Decodable, U>(_ type: T.Type, _ key: Key, map: @escaping (T) -> U?) -> Decode<[U]> {
        return Decode(f: { () throws -> [U] in
            var unkeyContainer = try nestedUnkeyedContainer(forKey: key)
            return unkeyContainer._decodeAny(type, map: map)
        })
    }
    
    //    func decode<T: Decodable>(_ key: Key) throws -> Decode<T> {
    //        return Decode(value: try decode(T.self, forKey: key))
    //    }
    
    //    func decode<T: Decodable, U>(_ key: Key, map: (T) -> U) -> Decode<U> {
    //        let value = map(try! decode(T.self, forKey: key))
    //        return Decode(value: value)
    //    }
    
    
}

extension UnkeyedDecodingContainer {
    mutating func _decodeAny<T: Decodable, U>(_ type: T.Type, map: (T) -> U?) -> [U] {
        var array: [U?] = []
        while !isAtEnd {
            do {
                array.append(map(try decode(T.self)))
            } catch {
                _ = try! decode(AnyCodable.self)
            }
        }
        return array.compactMap(id)
    }
    
    mutating func decodeAny<T: Decodable>(_ type: T.Type) -> Decode<[T]> {
        return Decode(f: { () throws -> [T] in
            return _decodeAny(type, map: id)
        })
    }
    
    mutating func decodeAny<T: Decodable, U>(_ type: T.Type, map: (T) -> U) -> Decode<[U]> {
        return Decode(f: { () -> [U] in
            return _decodeAny(type, map: map)
        })
    }
}
