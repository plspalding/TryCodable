//
//  KeyedDecodingContainerTests.swift
//  TryCodableTests
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

import XCTest
@testable import TryCodable

// MARK:- Standard decode function tests
class KeyedDecodingContainerTests: XCTestCase {
    
    func test_can_decode_simple_value() {
        struct A: Decodable {
            var name: String
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                name = container.decode(.name).valueElse("")
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.name == "James")
    }
    
    func test_can_decode_and_transform_simple_value() {
        struct A: Decodable {
            var name: String
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                name = container.decode(.name, map: { (s: String) in s.uppercased() }).valueElse("")
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.name == "JAMES")
    }
    
    func test_decode_simple_value_throws_error_when_necessary() {
        struct A: Decodable {
            var name: String = ""
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                name = try container.decode(.age).valueOrThrow()
            }
        }
        
        do {
            let _ = try JSONDecoder().decode(A.self, from: data)
            XCTFail()
        } catch {}
    }
    
    func test_decode_simple_value_throws_error_when_transform_fails() {
        struct A: Decodable {
            var name: String = ""
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                name = try container.decode(.name, map: { (s: String) in s.returnNil }).valueOrThrow()
            }
        }
        
        do {
            let _ = try JSONDecoder().decode(A.self, from: data)
            XCTFail()
        } catch {
            XCTAssert((error as! WrappedDecodingError).message == "Failed to transform data" )
        }
    }
}


// MARK:- Decode all tests
extension KeyedDecodingContainerTests {
    
    func test_can_decode_all_values() {
        struct A: Decodable {
            var names: [String]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                names = container.decode(.names).valueElse([])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.names == ["James", "Earl", "Jones"])
    }
    
    func test_can_decode_all_and_transform_values() {
        struct A: Decodable {
            var names: [String]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                names = container.decode(.names, map: { (s: String) in s.uppercased() }).valueElse([])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.names == ["JAMES", "EARL", "JONES"])
    }
    
    func test_decode_all_values_throws_error_when_necessary() {
        struct A: Decodable {
            var names: [String]

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                names = try container.decode(.age).valueOrThrow()
            }
        }

        do {
            let _ = try JSONDecoder().decode(A.self, from: data)
            XCTFail()
        } catch {}
    }

    func test_decode_all_value_throws_error_when_a_transform_fails() {
        struct A: Decodable {
            var names: [String]

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                names = try container.decode(.names, map: { (s: String) in s.returnNil }).valueOrThrow()
            }
        }

        do {
            let _ = try JSONDecoder().decode(A.self, from: data)
            XCTFail()
        } catch {
            XCTAssert((error as! WrappedDecodingError).message == "Failed to transform data at position: 0" )
        }
    }
}

// MARK:- Decode any tests
extension KeyedDecodingContainerTests {
    
    func test_can_decode_any_values_() {
        struct A: Decodable {
            var numbers: [Int]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                numbers = container.decode(any: Int.self, .numbers).valueElse([])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.numbers == [1,3,4])
    }
    
    func test_can_decode_any_and_transform_values() {
        struct A: Decodable {
            var numbers: [Int]

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                numbers = container.decode(any: Int.self, .numbers, map: { (i: Int) in i * 2 }).valueElse([])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.numbers == [2,6,8])
    }

    func test_decode_any_values_throws_error_when_key_does_not_exist() {
        struct A: Decodable {
            var numbers: [Int]

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                numbers = try container.decode(.age).valueOrThrow()
            }
        }

        do {
            let _ = try JSONDecoder().decode(A.self, from: data)
            XCTFail()
        } catch {}
    }
}


// MARK:- Decode KeyPath tests
extension KeyedDecodingContainerTests {
    
    func test_can_decode_and_transform_using_keyPath() {
        struct A: Decodable {
            var nameCount: Int
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                nameCount = container.decode(.name, map: \String.count ).valueElse(0)
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.nameCount == 5)
    }
    
    func test_can_decode_all_and_transform_using_keyPath() {
        struct A: Decodable {
            var countOfNames: [Int]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                countOfNames = container.decode(.names, map: \String.count ).valueElse([0])
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.countOfNames == [5,4,5])
    }
    
    func test_can_decode_any_and_tranform_transform_using_keyPath() {
        struct A: Decodable {
            var numbers: [Int]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                numbers = container.decode(any: Int.self, .numbers, map: \Int.double).valueElse([])
                
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: data)
        XCTAssert(a.numbers == [2,6,8])
    }
}
