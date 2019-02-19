//
//  SingleValueDecodingContainerTests.swift
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

class SingleValueDecodingContainerTests: XCTestCase {

    func test_can_decode_value() {
        struct A: Decodable {
            var name: String
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                name = container.decode().valueElse("")
            }
        }
        let a = try! JSONDecoder().decode(A.self, from: singlevalueData)
        XCTAssert(a.name == "James")
    }
}

//extension SingleValueDecodingContainer {
//
//    func decode<T: Decodable, U>(
//        map: (T) -> U?)
//        -> Decode<U>
//    {
//        return Decode {
//            guard let result = map(try decode(T.self)) else {
//                throw singleTransformError(container: self)
//            }
//            return result
//        }
//    }
//
//    func decode<T: Decodable>() -> Decode<T>
//    {
//        return decode(map: id)
//    }
//
//    func decode<T: Decodable, U>(
//        map: KeyPath<T, U>)
//        -> Decode<U>
//    {
//        return decode(map: ^map)
//    }
//
//    func decode<T: Decodable, U>(
//        map: KeyPath<T, U?>)
//        -> Decode<U>
//    {
//        return decode(map: ^map)
//    }
//}
//
