//
//  Helpers.swift
//  TryCodable
//
//  Created by Preston Spalding on 03/02/2019.
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

import Foundation

struct AnyCodable: Codable {}

extension String: Error { }

prefix operator ^

prefix func ^<A, B>(_ keyPath: KeyPath<A, B>) -> (A) -> B {
    return { a in
        a[keyPath: keyPath]
    }
}

func id<A>(_ value: A) -> A {
    return value
}

extension Optional {
    
    var isNil: Bool {
        return self == nil
    }
    
    var isNotNil: Bool {
        return !isNil
    }
}

public enum Logger {
    
    case inactive
    case active
    
    func perform(with error: Error, index: Int?) {
        switch self {
        case .inactive: break
        case .active:
            let indexMessage = index.isNotNil ? " Index: \(index!)" : ""
            
            guard let e = error as? DecodingError else { print("Unknown error: \(error)" + indexMessage); return }
            print(e.message + indexMessage)
        }
    }
}
