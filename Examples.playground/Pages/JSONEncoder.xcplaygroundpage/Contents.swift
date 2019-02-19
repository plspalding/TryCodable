//: [Previous](@previous)

import Foundation
import TryCodable

struct A: Encodable {
    let a: String
}

let a = A(a: "Value")

let data = try! a.encode()
data

//: [Next](@next)
