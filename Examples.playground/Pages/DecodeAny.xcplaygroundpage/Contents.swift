//: [Previous](@previous)
//: ### Decoding any elements in array
import Foundation
import Codable

struct Values {
    let a: [String]
    let b: [String]
    let c: [Int]
}

let data =
    """
{
    "a": ["a", "b"],
    "b": ["a", 5, 7],
    "c": ["1", "2", "3"]
}
""".data(using: .utf8)!


extension Values: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        a = try container.decode(any: String.self, .a).valueOrThrow()
        b = try container.decode(any: String.self, .b, log: .active).valueOrThrow()
        c = try container.decode(any: String.self, .c, map: { Int($0) }).valueOrThrow()
    }
    
    enum CodingKeys: CodingKey {
        case a
        case b
        case c
    }
}


let values = try! JSONDecoder().decode(Values.self, from: data)
values.a
values.b
values.c

//: [Next](@next)
