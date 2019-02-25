[![Build Status](https://travis-ci.com/plspalding/TryCodable.svg?branch=master)](https://travis-ci.com/plspalding/TryCodable)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TryCodable.svg)](https://img.shields.io/cocoapods/v/TryCodable.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/TryCodable.svg?style=flat)](https://trycodable.github.io/TryCodable)

# TryCodable

**IMPORTANT**: TryCodable is at the beginning of its life (0.1.0). There is a high possiblity of major changes in regards to renames, structual changes, new functionality etc within the poject itself, the good news is that the api should remain pretty solid and thus any changes should hopefully not affect anyone too much. TryCodable was written with an API first approach. However with any new project unforseen circumstances may result in unforseen changes. Please bear with me :-).

A small wrapper around Codable allowing users to have more flexibility when decoding and encoding values.

## Requirements
- iOS 10.0+
- Xcode 10.1+
- Swift 4.2+

## Getting Started

### CocoaPods
CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate TryCodable into your Xcode project using CocoaPods, specify it in your Podfile:

`pod 'TryCodable', '~>0.1.0'`

### Carthage
Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate TryCodable into your Xcode project using Carthage, specify it in your Cartfile:

`github "plspalding/TryCodable" "0.1.0"`

### Manually using git submodules
Add TryCodable as a submodule

`$ git submodule add https://github.com/plspalding/TryCodable.git`

Drag `TryCodable.xcodeproj` into Project Navigator
Go to `Project > Targets > Build Phases > Link Binary With Libraries`, click `+` and select `TryCodable-[Platform]` target

## How to use

Let take a look at a basic implemention of Decoding a Struct using Codable.

```
struct Person: Decodable {
    let name: String
    let age: Int
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        let ageAString = try container.decode(String.self, forKey: .age)
        age = Int(ageAString)!
    }
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
}
```

As you can see from the above code we need to tell it what to decode into by saying `forKey`. Also because age is a String from our server, we need to decode age into a temporary variable before being able to convert it into the Int value we want.

Now lets look what this code would like using `TryCodable`.

```
struct Person: Decodable {
    let name: String
    let age: Int
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(.name).valueOrThrow()
        age = try container.decode(.age, map: { Int($0) }).valueOrThrow()
    }
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
}
```

The first thing we see here is that we are inferring the type from the return type. So we can remove the need for `Type.self`. Also in the age example instead of having a temporary variable we can just map over the value and covert it inline.

You will have noticed the `valueOrThrow()` function. When we call `try container.decode(.name)` we get back an enum which is holding either the `successful` case or the `error` case. However you never need to switch on this case because functions are provided to do everything you need.

The three main functions here are:

`valueOrThrow` - Gives you back the value if it exists or throws the error.

`valueOrNil` - Gives you back the value if it exists or returns nil.

`valueElse` - Gives you back the value if it exists otherwise gives back the value that you place into the else.
