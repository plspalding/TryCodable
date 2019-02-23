//
//  JSONDecoderTests.swift
//  TryCodableTests
//
//  Created by Preston Spalding on 17/02/2019.
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

class DataJSONDecoderTests: XCTestCase {

    func test_able_to_decode_data_correctly() {
        
        struct A: Decodable {
            var name: String
            
            init(name: String) {
                self.name = name
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                name = container.decode(.name).valueElse("")
            }
        }
        let a = try! data.decode(as: A.self).valueElse(A(name: ""))
        XCTAssert(a.name == "James")
    }
    
    func test_able_to_decode_data_correctly_then_map() {
        
        struct A: Decodable {
            var name: String
            
            init(name: String) {
                self.name = name
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                name = container.decode(.name).valueElse("")
            }
        }
        let a = try! data.decode(as: A.self).map { A(name: $0.name.uppercased() ) }.valueElse(A(name: ""))
        XCTAssert(a.name == "JAMES")
    }
    
    func test_able_to_pass_in_our_own_json_decoder() {
        
        struct A: Decodable {
            var firstName: String
            
            init(firstName: String) {
                self.firstName = firstName
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                firstName = try container.decode(.firstName).valueOrThrow()
            }
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let a = try! camelCaseKeyData.decode(as: A.self, jsonDecoder: decoder).valueOrThrow()
        XCTAssert(a.firstName == "James")
    }

}
