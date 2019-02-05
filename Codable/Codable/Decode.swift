//
//  Decode.swift
//  Codable
//
//  Created by Preston Spalding on 31/01/2019.
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

public enum Decode<T> {
    case successful(T)
    case failure(Error)
    init(f: () throws -> T) {
        do {
            self = .successful(try f())
        } catch {
            self = .failure(error)
        }
    }
    
    public func valueOrThrow(
        file: String = #file,
        function: String = #function,
        line: Int = #line)
        throws -> T
    {
        switch self {
        case .successful(let value): return value
        case .failure(let e):
            let error = WrappedDecodingError(decodingError: e as? DecodingError, file: file, function: function, line: line)
            throw error
        }
    }
    
    public func valueOrNil() -> T? {
        switch self {
        case .successful(let value): return value
        case .failure: return nil
        }
    }
    
    public func valueElse(_ defaultValue: @autoclosure () -> T, log: Logger = .inactive) -> T {
        switch self {
        case .successful(let value): return value
        case .failure(let error):
            log.perform(with: error, index: nil)
            return defaultValue()
        }
    }
    
    public func map<U>(_ f: (T) -> U) -> Decode<U> {
        switch self {
        case .successful(let value):
            return .successful(f(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func flatMap<U>(_ f: (T) -> Decode<U>) -> Decode<U> {
        switch self {
        case .successful(let value):
            return f(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}
