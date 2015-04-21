//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Quick
import Nimble

import Argo

class JSONAdapterSpec: QuickSpec {
    override func spec() {
        describe("A JSONAdapter") {
            let adapter = NodeAdapters.json

            let value = Node(children: [ Node(children: []), Node(children: []) ])
            let transformedValue: JSONValue = .JSONObject([
                "children": .JSONArray([
                    .JSONObject([ "children": .JSONArray([]) ]),
                    .JSONObject([ "children": .JSONArray([]) ])
                ])
            ])

            it("should transform a value") {
                let result = adapter.transform(value)

                expect(result.value).to(equal(transformedValue))
            }

            it("should reverse transform a value") {
                let result = adapter.reverseTransform(transformedValue)

                expect(result.value).to(equal(value))
            }
        }
    }
}
