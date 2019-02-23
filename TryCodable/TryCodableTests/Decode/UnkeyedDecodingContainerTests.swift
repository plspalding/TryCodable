//
//  UnkeyedDecodingContainerTests.swift
//  TryCodableTests
//
//  Created by Preston Spalding on 09/02/2019.
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

import XCTest
@testable import TryCodable

// MARK:- Decode all function tests
class UnkeyedDecodingContainerTests: XCTestCase {

    func test_decode_all() {
        struct A: Decodable {
            var names: [String]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .names)
                names = unkeyedContainer.decode().valueElse([])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.names == ["James", "Earl", "Jones"])
    }
    
    func test_decode_all_and_transform() {
        struct A: Decodable {
            var names: [String]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .names)
                names = unkeyedContainer.decode(map: { (s: String) in s.uppercased() }).valueElse([])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.names == ["JAMES", "EARL", "JONES"])
    }
}

// MARK:- Decode any
extension UnkeyedDecodingContainerTests {
    
    func test_decode_any() {
        struct A: Decodable {
            var numbers: [Int]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .numbers)
                numbers = unkeyedContainer.decode(any: Int.self).valueElse([])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.numbers == [1,3,4])
    }
    
    func test_decode_any_and_transform() {
        struct A: Decodable {
            var numbers: [Int]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .numbers)
                numbers = unkeyedContainer.decode(any: Int.self, map: { $0 * 2 }).valueElse([])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.numbers == [2,6,8])
    }
}

// MARK:- Decode keyPaths

extension UnkeyedDecodingContainerTests {
    
    func test_decode_any_transforming_with_keyPath() {
        struct A: Decodable {
            var numbers: [Int]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .numbers)
                numbers = unkeyedContainer.decode(any: Int.self).valueElse([])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.numbers == [1,3,4])
    }
    
    func test_decode_any_and_transform_with_keyPath() {
        struct A: Decodable {
            var numbers: [Int]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .numbers)
                numbers = unkeyedContainer.decode(any: Int.self, map: { $0 * 2 }).valueElse([])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.numbers == [2,6,8])
    }
}
