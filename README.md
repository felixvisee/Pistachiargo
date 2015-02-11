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
struct Origin {
  var city: String

  init(city: String = "") {
    self.city = city
  }
}
```

```swift
struct OriginLenses {
  static let city = Lens<Origin, String>(get: { $0.city }, set: { (inout origin: Origin, city) in
    origin.city = city
  })
}
```

```swift
struct Person {
  var name: String
  var age: Int
  var origin: Origin?
  var children: [Person]?

  init(name: String = "", age: Int = 0, origin: Origin? = nil, children: [Person]? = nil) {
    self.name = name
    self.age = age
    self.origin = origin
    self.children = children
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

However, Pistachiargo ships with a lot of JSON value transformers, convenience functions and a JSON adapter:

```swift
struct JSONAdapters {
  static let origin = JSONAdapter(specification: [
    "city_name": JSONString(OriginLenses.city)
  ])

  static let person: JSONAdapter<Person> = fix { adapter in
    return JSONAdapter(specification: [
      "name": JSONString(PersonLenses.name),
      "age": JSONNumber(PersonLenses.age),
      "origin": JSONObject(PersonLenses.origin)(adapter: origin, model: Origin()),
      "children": JSONArray(PersonLenses.children)(adapter: adapter, model: Person())
    ])
  }
}
```

JSON adapters handle encoding to and decoding from JSON:

```swift
let adapter = JSONAdapters.person

var person = Person(name: "Felix", origin: Origin(city: "Berlin"))
var data = adapter.encode(person)
// == .Success(Box(.JSONObject([
//   "name": .JSONString("Felix"),
//   "age": .JSONNumber(0),
//   "origin": .JSONObject([
//     "city_name": .JSONString("Berlin")
//   ]),
//   "children": .JSONNull
// ])))

adapter.decode(Person(), from: data.value!)
// == .Success(Box(person))
```

The return value of both `encode` and `decode` is a `Result` (by [LlamaKit](https://github.com/LlamaKit/LlamaKit)), which either holds the encoded/decoded value or an error. This enables you to gracefully handle coding errors.

For more documentation on lenses, value transformers and adapters, please see [Pistachio](https://github.com/felixjendrusch/Pistachio).

## About

Pistachiargo was built by [Felix Jendrusch](http://felixjendrusch.is). Greetings from Berlin :wave:
