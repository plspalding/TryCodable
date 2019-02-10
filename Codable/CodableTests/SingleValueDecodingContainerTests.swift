//
//  SingleValueDecodingContainerTests.swift
//  CodableTests
//
//  Created by Preston Spalding on 09/02/2019.
//  Copyright © 2019 Preston Spalding. All rights reserved.
//

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
