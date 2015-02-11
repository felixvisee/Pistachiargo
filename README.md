# Pistachiargo

Pistachiargo is a model framework using [Argo](https://github.com/thoughtbot/Argo). It's based on [Pistachio](https://github.com/felixjendrusch/Pistachio).

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa. You can install it with [Homebrew](http://brew.sh) using the following commands:

```
$ brew update
$ brew install carthage
```

Next, add Pistachiargo to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "felixjendrusch/Pistachiargo"
```

Afterwards, run `carthage update` to actually fetch Pistachiargo.

Finally, on your application target's "General" settings tab, in the "Linked Frameworks and Libraries" section, add `Pistachiargo.framework` from the [Carthage/Build](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#carthagebuild) folder on disk.

## Usage

Like [Pistachio](https://github.com/felixjendrusch/Pistachio), Pistachiargo is all about [lenses](http://chris.eidhof.nl/posts/lenses-in-swift.html):

```swift
struct Person {
  var name: String = ""
  var age: Int = 0
  var origin: Origin? = nil
  var children: [Person]? = nil

  init() {}

  init(name: String, origin: Origin) {
    self.name = name
    self.origin = origin
  }
}
```

```swift
struct Origin {
  var city: String = ""

  init() {}

  init(city: String) {
    self.city = city
  }
}
```

```swift
struct PersonLenses {
  static let name = Lens<Person, String>(get: { $0.name }, set: { (inout person: Person, name) in
    person.name = name
  })

  static let age = Lens<Person, Int>(get: { $0.age }, set: { (inout person: Person, age) in
    person.age = age
  })

  static let origin = Lens<Person, Origin?>(get: { $0.origin }, set: { (inout person: Person, origin) in
    person.origin = origin
  })

  static let children = Lens<Person, [Person]?>(get: { $0.children }, set: { (inout person: Person, children) in
    person.children = children
  })
}
```

```swift
struct OriginLenses {
  static let city = Lens<Origin, String>(get: { $0.city }, set: { (inout origin: Origin, city) in
    origin.city = city
  })
}
```

However, Pistachiargo ships with a lot of JSON value transformers, convenience functions and a JSON adapter:

```swift
struct JSONAdapters {
  static let origin = JSONAdapter(specification: [
    "city": JSONString(OriginLenses.city)
  ])

  static let person: JSONAdapter<Person> = fix { adapter in
    return JSONAdapter(specification: [
      "name": JSONString(PersonLenses.name),
      "age": JSONNumber(PersonLenses.age),
      "city": JSONObject(PersonLenses.origin, .JSONNull)(adapter: origin, model: Origin()),
      "children": JSONArray(PersonLenses.children, .JSONNull)(adapter: adapter, model: Person())
    ])
  }
}
```

JSON adapters handle encoding to and decoding from JSON:

```swift
let adapter = JSONAdapters.person

var person = Person(name: "Felix", origin: Origin(city: "Berlin"))
var data = adapter.encode(person) // == .Success(Box(.JSONObject([ "name": .JSONString("Seb"), "origin": .JSONObject([ "city": .JSONString("Berlin") ]) ])))
adapter.decode(Person(), from: data.value!) // == .Success(Box(person))
```

The return value of both `encode` and `decode` is a `Result` (by [LlamaKit](https://github.com/LlamaKit/LlamaKit)), which either holds the encoded/decoded value or an error. This enables you to gracefully handle coding errors.

For more documentation on lenses, value transformers and adapters, please see [Pistachio](https://github.com/felixjendrusch/Pistachio).

## About

Pistachiargo was built by [Felix Jendrusch](http://felixjendrusch.is). Greetings from Berlin :wave:
