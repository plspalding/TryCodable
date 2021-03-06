//
//  TryCodable.swift
//  TryCodable
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

public enum TryCodable<T> {
    case successful(T)
    case failure(DecodingError)
    init(f: () throws -> T) {
        do {
            self = .successful(try f())
        } catch let error as DecodingError {
            self = .failure(error)
        } catch {
            let decodingError = DecodingError.unknown(codingPath: [], error: error)
            self = .failure(decodingError)
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
            let error = WrappedDecodingError(
                decodingError: e,
                file: file,
                function: function,
                line: line
            )
            
            // We want to check if an underlying error is a WrappedDecodingError. If so then we just want to
            // return the underlying error as that will be the first point in which the users code failed.
            switch error.decodingError {
            case .dataCorrupted(let context):
                if let wrappedError = context.underlyingError as? WrappedDecodingError {
                    throw wrappedError
                }
            default:
                throw error
            }
            
            throw error
        }
    }
    
    public func valueOrNil() -> T? {
        switch self {
        case .successful(let value): return value
        case .failure: return nil
        }
    }
    
    // TODO: Add better logging. Maybe append with Failed to parse.
    public func valueElse(_ defaultValue: @autoclosure () -> T, log: Logger = .inactive) -> T {
        switch self {
        case .successful(let value): return value
        case .failure(let error):
            log.perform(with: error, index: nil)
            return defaultValue()
        }
    }
    
    public func map<U>(_ f: (T) -> U) -> TryCodable<U> {
        switch self {
        case .successful(let value):
            return .successful(f(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func flatMap<U>(_ f: (T) -> TryCodable<U>) -> TryCodable<U> {
        switch self {
        case .successful(let value):
            return f(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension TryCodable: Equatable where T: Equatable {
    public static func ==(lhs: TryCodable, rhs: TryCodable) -> Bool {
        switch (lhs, rhs) {
        case let (.successful(v), .successful(v1)): return v == v1
        case let (.failure(e), .failure(e1)):
            return e.errorDescription == e1.errorDescription
                && e.failureReason == e1.failureReason
                && e.helpAnchor == e1.helpAnchor
                && e.localizedDescription == e1.localizedDescription
                && e.recoverySuggestion == e1.recoverySuggestion
        case (_, _): return false
        }
    }
}
