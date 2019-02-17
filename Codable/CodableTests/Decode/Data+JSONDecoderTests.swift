//
//  JSONDecoderTests.swift
//  CodableTests
//
//  Created by Preston Spalding on 17/02/2019.
//  Copyright © 2019 Preston Spalding. All rights reserved.
//

import XCTest
@testable import Codable

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
