//: [Previous](@previous)
//: ### Basic Decoding Examples
import Foundation
import TryCodable

struct Values {
    let a: String
    let b: String
    let c: Int?
    let d: Int
    let e: Int
}

let data =
"""
{
    "a": "a",
    "b": "b",
    "c": 5,
    "d": "5",
    "e": "6",
}
""".data(using: .utf8)!


extension Values: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        a = try container.decode(.a).valueOrThrow()
        b = try container.decode(.b, map: { (s: String) in s.uppercased() }).valueOrThrow()
        c = container.decode(.c).valueOrNil()
        d = container.decode(.d).valueElse(10)
        e = container.decode(.e).valueElse(12, log: .active) // You will see print out in Debug area
    }
    
    enum CodingKeys: CodingKey {
        case a
        case b
        case c
        case d
        case e
    }
}


let values = try! JSONDecoder().decode(Values.self, from: data)
values.a
values.b
values.c
values.d
values.e

//: [Next](@next)
