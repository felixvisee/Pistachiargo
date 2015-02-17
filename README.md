# Pistachiargo

Pistachiargo is a model framework using [Argo](https://github.com/thoughtbot/Argo). It's based on [Pistachio](https://github.com/felixjendrusch/Pistachio).

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa. You can install it with [Homebrew](http://brew.sh) using the following commands:

```
$ brew update
$ brew install carthage
```

1. Add Pistachiargo to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):
  ```
  github "felixjendrusch/Pistachiargo" ~> 0.1
  ```

2. Run `carthage update` to fetch and build Pistachiargo and its dependencies.

3. On your application target's "General" settings tab, in the "Linked Frameworks and Libraries" section, add the following frameworks from the [Carthage/Build](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#carthagebuild) folder on disk:
  - `Pistachiargo.framework`

4. On your application target's "Build Phases" settings tab, click the "+" icon and choose "New Run Script Phase". Create a Run Script with the following contents:
  ```
  /usr/local/bin/carthage copy-frameworks
  ```
  and add the following paths to the frameworks under "Input Files":
  ```
  $(SRCROOT)/Carthage/Build/iOS/LlamaKit.framework
  $(SRCROOT)/Carthage/Build/iOS/Pistachio.framework
  $(SRCROOT)/Carthage/Build/iOS/Runes.framework
  $(SRCROOT)/Carthage/Build/iOS/Argo.framework
  $(SRCROOT)/Carthage/Build/iOS/Pistachiargo.framework
  ```
  This script works around an [App Store submission bug](http://www.openradar.me/radar?id=6409498411401216) triggered by universal binaries.

## Usage

Like [Pistachio](https://github.com/felixjendrusch/Pistachio), Pistachiargo leverages [lenses](http://chris.eidhof.nl/posts/lenses-in-swift.html) and value transformers to create type safe adapters:

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
  static let city = Lens(get: { $0.city }, set: { (inout origin: Origin, city) in
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

Both `encode` and `decode` return a [`LlamaKit.Result`](https://github.com/LlamaKit/LlamaKit/blob/master/LlamaKit/Result.swift), which either holds the encoded/decoded value or an error. This enables you to gracefully handle coding errors.

For more documentation on lenses, value transformers and adapters, please see [Pistachio](https://github.com/felixjendrusch/Pistachio).

## Posts

- [Working with immutable models in Swift](https://github.com/felixjendrusch/blog/blob/master/_posts/2015-02-14-working-with-immutable-models-in-swift.md) (February 14, 2015)

## About

Pistachiargo was built by [Felix Jendrusch](http://felixjendrusch.is). Greetings from Berlin :wave:
