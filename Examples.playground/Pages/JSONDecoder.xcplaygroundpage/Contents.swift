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

// You can either use the as: parameter to tell the compiler what you are decoding into.
let a = try! data.decode(as: A.self).valueOrThrow()
a.a

// Or we can specifiy the type on the left hand side of the expression.
let a1: A = try! data.decode().valueOrThrow()

// However when using map it's best to use the as: parameter as we need to tell the compiler
// what it is decoding. However because the map can change the type, we can't always rely on the
// return type helping us out here as with the previous examples.
let a2 = try! data.decode(as: A.self).map { A(a: $0.a.uppercased()) }.valueOrThrow()
a1.a

//: [Next](@next)
