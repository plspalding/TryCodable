//: [Previous](@previous)

import Foundation
import TryCodable

struct Value {
    let a: Int
    let b: [Int]
}

let data =
    """
{
    "a": "2",
    "b": ["1", "2dsf"]
}
""".data(using: .utf8)!


extension Value: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        a = try container.decode(.a, map: {(s: String) in Int(s) }).valueOrThrow()
        b = try container.decode(.b, map: {(s: String) in Int(s) }).valueOrThrow()
    }
    
    enum CodingKeys: CodingKey {
        case a
        case b
    }
}


do {
    let value = try JSONDecoder().decode(Value.self, from: data)
    value.a
    value.b
} catch let error as WrappedDecodingError {
    
//    error.decodingError
    print(error.decodingError)
    
    // The following attributes allow you to pin point exactly where decoding failed.
    print(error.file)
    print(error.function)
    print(error.line)
}

//: [Next](@next)
