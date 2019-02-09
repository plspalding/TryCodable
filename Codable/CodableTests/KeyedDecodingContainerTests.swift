//
//  KeyedDecodingContainerTests.swift
//  CodableTests
//
//  Created by Preston Spalding on 05/02/2019.
//  Copyright © 2019 Preston Spalding. All rights reserved.
//

import XCTest
@testable import Codable

private enum CodingKeys: CodingKey {
    case name
    case names
    case numbers
    case age
}


private let data =
"""
{
"name": "James",
"names": ["James", "Earl", "Jones"],
"numbers": [1, "2", 3, 4, "5"]
}
""".data(using: .utf8)!

extension String {
    var returnNil: String? {
        return nil
    }
}

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
            var names: [String] = []
            
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
            var names: [String] = []
            
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
            var names: [String] = []

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
            var numbers: [Int] = []
            
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
            var numbers: [Int] = []

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
