//
//  Decode.swift
//  CodableTests
//
//  Created by Preston Spalding on 06/02/2019.
//  Copyright © 2019 Preston Spalding. All rights reserved.
//

import XCTest
@testable import Codable

class DecodeTests: XCTestCase {
    
    let testDecodeError: DecodingError =
        .dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Test Error"))
    
    func test_valueOrThrow_returns_value() {
        let decode = Decode.successful("Value")
        XCTAssert(try! decode.valueOrThrow() == "Value")
    }
    
    func test_valueOrThrow_throws_error_if_value_is_nil() {
        
        let decode = Decode<String>.failure(testDecodeError)
        
        do {
            let _ = try decode.valueOrThrow()
            XCTFail("Should throw when we have failure case")
        } catch {
            XCTAssert((error as! WrappedDecodingError).message == "Test Error")
        }
    }
    
    func test_valueOrNil_returns_value() {
        let decode = Decode.successful("Value")
        XCTAssert(decode.valueOrNil() == "Value")
    }
    
    func test_valueOrNil_returns_nil_if_value_is_nil() {
        let decode = Decode<String>.failure(testDecodeError)
        XCTAssert(decode.valueOrNil() == nil)
    }
    
    func test_valueOrElse_returns_value() {
        let decode = Decode<String>.successful("Value")
        XCTAssert(decode.valueElse("Default") == "Value")
    }
    
    func test_valueOrElse_returns_else_value() {
        let decode = Decode<String>.failure(testDecodeError)
        XCTAssert(decode.valueElse("Default") == "Default")
    }
}

