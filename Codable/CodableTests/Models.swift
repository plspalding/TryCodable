//
//  Models.swift
//  CodableTests
//
//  Created by Preston Spalding on 06/02/2019.
//  Copyright © 2019 Preston Spalding. All rights reserved.
//

import Foundation

//class KeyedDecodingContainerTests: XCTestCase {
//
//    func test_can_decode_simple_value() {
//
//        let a = A(key: CodingKeys.a) { (container, k) -> String in
//            let value = container.decode(k).valueElse("Hello", log: .active)
//
//            print("================= + \(value)")
//            return value
//        }
//
//        a.test(a: a)
//        //        let b = A.B(from: )
//
//        enum CodingKeys: CodingKey {
//            case a
//        }
//    }
//}

//let data =
//    """
//    {
//        "a": "Value"
//    }
//    """.data(using: .utf8)!
//
//class A<T: Decodable, K: CodingKey> {
//    
//    let key: K
//    let g: (KeyedDecodingContainer<K>, K) -> T //= { _ in fatalError() }
//    //let a: T
//    
//    init (key: K, f: @escaping (KeyedDecodingContainer<K>, K) -> T) {
//        self.key = key
//        g = f
//    }
//    
//    func test(a: A) {
//        let result = try! JSONDecoder().decode(A.B.self, from: data)
//        print("BOOOM!!!!! + \(result)")
//    }
//    
////    required init(from decoder: Decoder) {
////        let container = try! decoder.container(keyedBy: K.self)
////    }
//    
//    class B: Decodable {
//        
//        static var a: A!
//        
//        required init(from decoder: Decoder) {
//            let container = try! decoder.container(keyedBy: K.self)
//            
////            container.decode(T.self) { (Decodable) -> Decodable? in
////                return nil
////            }
//            
////            let _ = a.g(container, a.key)
//        }
//        
//        enum CodingKeys: CodingKey {
//            case a
//        }
//    }
//    
//    
//}
//
//class Values<T>: NSObject {
//    
//    let f: (CodingKey) -> T
//    
//    var a: String = ""
//    var b: Int = 0
//    
//    public enum CodingKeys: CodingKey {
//        case a
//        case b
//    }
//    
//    init(f: @escaping (CodingKey) -> T) {
//        self.f = f
//    }
//    
//    
//}
//
