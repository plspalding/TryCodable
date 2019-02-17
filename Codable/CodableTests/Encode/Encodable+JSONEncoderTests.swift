//
//  JSONEncoderTests.swift
//  CodableTests
//
//  Created by Preston Spalding on 17/02/2019.
//  Copyright © 2019 Preston Spalding. All rights reserved.
//

import XCTest
@testable import Codable

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
