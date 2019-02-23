//: [Previous](@previous)

import Foundation
import TryCodable

let data =
    """
{
    "a": "a",
}
""".data(using: .utf8)!

struct A: Decodable {
    let a: String
}

let a = try! data.decode(as: A.self).valueOrThrow()
a.a

let a1 = try! data.decode(as: A.self).map { A(a: $0.a.uppercased()) }.valueOrThrow()
a1.a

//: [Next](@next)
