# Pistachiargo

Pistachiargo is a model framework using [Argo](https://github.com/thoughtbot/Argo). It's based on [Pistachio](https://github.com/felixjendrusch/Pistachio).

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

1. Add Pistachiargo to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

  ```
  github "felixjendrusch/Pistachiargo" ~> 0.2
  ```

2. Run `carthage update` to fetch and build Pistachiargo and its dependencies.

3. [Make sure your application's target links against `Pistachiargo.framework` and copies all relevant frameworks into its application bundle (iOS); or embeds the binaries of all relevant frameworks (Mac).](https://github.com/carthage/carthage#getting-started)

## Usage

Like [Pistachio](https://github.com/felixjendrusch/Pistachio), Pistachiargo leverages [lenses](http://chris.eidhof.nl/posts/lenses-in-swift.html) and value transformers to create type safe adapters. Let's start by defining a very simple model:

```swift
struct Origin {
  var city: String

  init(city: String = "") {
    self.city = city
  }
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

A lens is basically just a combination of a getter and a setter, providing a view on your model:

```swift
struct OriginLenses {
  static let city = Lens(get: { $0.city }, set: { (inout origin: Origin, city) in
    origin.city = city
  })
}
```

```swift
struct PersonLenses {
  static let name = Lens(get: { $0.name }, set: { (inout person: Person, name) in
    person.name = name
  })

  static let age = Lens(get: { $0.age }, set: { (inout person: Person, age) in
    person.age = age
  })

  static let origin = Lens(get: { $0.origin }, set: { (inout person: Person, origin) in
    person.origin = origin
  })

  static let children = Lens(get: { $0.children }, set: { (inout person: Person, children) in
    person.children = children
  })
}
```

However, Pistachiargo ships with a lot of JSON value transformers, convenience functions and a JSON adapter:

```swift
struct JSONAdapters {
  static let origin = JSONAdapter(specification: [
    "city_name": JSONString(OriginLenses.city)
  ], value: Origin())

  static let person = fix { adapter in
    return JSONAdapter(specification: [
      "name": JSONString(PersonLenses.name),
      "age": JSONNumber(PersonLenses.age),
      "origin": JSONObject(PersonLenses.origin)(adapter: origin),
      "children": JSONArray(PersonLenses.children)(adapter: adapter)
    ], value: Person())
  }
}
```

JSON adapters handle transforming and reverse transforming your models:

```swift
let adapter = JSONAdapters.person

var person = Person(name: "Felix", origin: Origin(city: "Berlin"))
var data = adapter.transform(person)
// == .Success(Box(.JSONObject([
//   "name": .JSONString("Felix"),
//   "age": .JSONNumber(0),
//   "origin": .JSONObject([
//     "city_name": .JSONString("Berlin")
//   ]),
//   "children": .JSONNull
// ])))

adapter.reverseTransform(data.value!)
// == .Success(Box(person))
```

Both `transform` and `reverseTransform` return a [`Result`](https://github.com/antitypical/Result/blob/master/Result/Result.swift), which either holds the (reverse) transformed value or an error. This enables you to gracefully handle transformation errors.

## Posts

- [Working with immutable models in Swift](https://github.com/felixjendrusch/blog/blob/master/_posts/2015-02-14-working-with-immutable-models-in-swift.md) (February 14, 2015)
