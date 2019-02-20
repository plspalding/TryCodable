//
//  Decode.swift
//  TryCodableTests
//
//  Created by Preston Spalding on 06/02/2019.
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

class DecodeTests: XCTestCase {
    
    let testDecodeError: DecodingError =
        .dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Test Error"))
    
    func test_valueOrThrow_returns_value() {
        let decode = TryCodable.successful("Value")
        XCTAssert(try! decode.valueOrThrow() == "Value")
    }
    
    func test_valueOrThrow_throws_error_if_value_is_nil() {
        
        let decode = TryCodable<String>.failure(testDecodeError)
        
        do {
            let _ = try decode.valueOrThrow()
            XCTFail("Should throw when we have failure case")
        } catch {
            XCTAssert((error as! WrappedDecodingError).message == "Test Error")
        }
    }
    
    func test_valueOrNil_returns_value() {
        let decode = TryCodable.successful("Value")
        XCTAssert(decode.valueOrNil() == "Value")
    }
    
    func test_valueOrNil_returns_nil_if_value_is_nil() {
        let decode = TryCodable<String>.failure(testDecodeError)
        XCTAssert(decode.valueOrNil() == nil)
    }
    
    func test_valueOrElse_returns_value() {
        let decode = TryCodable<String>.successful("Value")
        XCTAssert(decode.valueElse("Default") == "Value")
    }
    
    func test_valueOrElse_returns_else_value() {
        let decode = TryCodable<String>.failure(testDecodeError)
        XCTAssert(decode.valueElse("Default") == "Default")
    }
}

