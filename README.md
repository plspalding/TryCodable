# TryCodable

A small wrapper around Codable allowing users to have more flexibility when decoding and encoding values.

### Getting Started

// TODO: Add varous ways to install `TryCodable`.


### How to use

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
