//
//  JSONEncoderTests.swift
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

class EncodableJSONEncoderTests: XCTestCase {

    
    func test_encode_on_encodable_values() {
        
        struct A: Encodable {
            let name: String
        }
        
        let a = A(name: "James")
        let value = try! a.encode()
        
        let testData = try! JSONEncoder().encode(a)
        
        XCTAssert(value == testData)
    }
    
    func test_can_pass_own_encoder_to_encode_function() {
        
        struct A: Codable, Equatable {
            let firstName: String
        }
        
        let a = A(firstName: "James")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let data = try! a.encode(jsonEncoder: encoder)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase // If you remove this line the code fails as we have encoded using snakeCase
        
        do {
            let valueToTest = try decoder.decode(A.self, from: data)
            XCTAssert(valueToTest == A(firstName: "James"))
        } catch {
            XCTFail()
        }
    }
}
