//
//  DecodableError.swift
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

public struct WrappedDecodingError: Error {
    public let decodingError: DecodingError
    
    public let file: String
    public let function: String
    public let line: Int
    
    var message: String {
        return decodingError.message
    }
}

func keyedTransformError<K: CodingKey>(
    key: K,
    container: KeyedDecodingContainer<K>)
    -> DecodingError
{
    return .dataCorruptedError(forKey: key, in: container, debugDescription: "Failed to transform data")
}

func unkeyedTransformError(
    container: UnkeyedDecodingContainer,
    index: Int)
    -> DecodingError
{
    return .dataCorruptedError(in: container, debugDescription: "Failed to transform data at position: \(index)")
}

func singleTransformError(
    container: SingleValueDecodingContainer)
    -> DecodingError
{
    return .dataCorruptedError(in: container, debugDescription: "Failed to transform data")
}

func transformError()
    -> DecodingError
{
    return .dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Failed to transform data"))
}

extension DecodingError {
    public var message: String {
        switch self {
        case let .typeMismatch(_, context):
            return context.debugDescription
        case let .valueNotFound(_, context):
            return context.debugDescription
        case let .keyNotFound(_, context):
            return context.debugDescription
        case let .dataCorrupted(context):
            return context.debugDescription
        }
    }
    
    public static func unknown(
        codingPath: [CodingKey],
        error: Error)
        -> DecodingError
    {
        return .dataCorrupted(
            DecodingError.Context.init(
                codingPath: codingPath,
                debugDescription: "Unknown error. See underlying Error for more details",
                underlyingError: error
            )
        )
    }
}
