//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Quick
import Nimble

import Argo
import Pistachiargo

class JSONValueTransformersSpec: QuickSpec {
    override func spec() {
        describe("An NSNumber to JSONValue value transformer") {
            let valueTransformer = JSONValueTransformers.nsNumber

            it("should transform a value") {
                let result = valueTransformer.transform(NSNumber(integer: 1))

                expect(result.value).to(equal(JSONValue.JSONNumber(1)))
            }

            it("should reverse transform a value") {
                let result = valueTransformer.reverseTransform(.JSONNumber(2.5))

                expect(result.value).to(equal(NSNumber(float: 2.5)))
            }

            it("should fail if its value transformation fails") {
                let result = valueTransformer.reverseTransform(.JSONString("3"))

                expect(result.value).to(beNil())
            }
        }

        describe("A String to JSONValue value transformer") {
            let valueTransformer = JSONValueTransformers.string

            it("should transform a value") {
                let result = valueTransformer.transform("foo")

                expect(result.value).to(equal(JSONValue.JSONString("foo")))
            }

            it("should reverse transform a value") {
                let result = valueTransformer.reverseTransform(.JSONString("bar"))

                expect(result.value).to(equal("bar"))
            }

            it("should fail if its value transformation fails") {
                let result = valueTransformer.reverseTransform(.JSONArray([ .JSONString("foobar") ]))

                expect(result.value).to(beNil())
            }
        }

        describe("A Bool to JSONValue value transformer") {
            let valueTransformer = JSONValueTransformers.bool

            it("should transform a value") {
                let result = valueTransformer.transform(true)

                expect(result.value).to(equal(JSONValue.JSONNumber(true)))
            }

            it("should reverse transform a value") {
                let result = valueTransformer.reverseTransform(.JSONNumber(false))

                expect(result.value).to(equal(false))
            }

            it("should fail if its value transformation fails") {
                let result = valueTransformer.reverseTransform(.JSONString("foobar"))

                expect(result.value).to(beNil())
            }
        }

        describe("A [String: JSONValue] to JSONValue value transformer") {
            let valueTransformer = JSONValueTransformers.dictionary

            it("should transform a value") {
                let result = valueTransformer.transform([ "foo": .JSONString("bar") ])

                expect(result.value).to(equal(JSONValue.JSONObject([ "foo": .JSONString("bar") ])))
            }

            it("should reverse transform a value") {
                let result = valueTransformer.reverseTransform(.JSONObject([ "bar": .JSONString("foo") ]))

                expect(result.value).to(equal([ "bar": .JSONString("foo") ]))
            }

            it("should fail if its value transformation fails") {
                let result = valueTransformer.reverseTransform(.JSONString("foobar"))

                expect(result.value).to(beNil())
            }
        }

        describe("A [JSONValue] to JSONValue value transformer") {
            let valueTransformer = JSONValueTransformers.array

            it("should transform a value") {
                let result = valueTransformer.transform([ .JSONString("foo") ])

                expect(result.value).to(equal(JSONValue.JSONArray([ .JSONString("foo") ])))
            }

            it("should reverse transform a value") {
                let result = valueTransformer.reverseTransform(.JSONArray([ .JSONString("bar") ]))

                expect(result.value).to(equal([ .JSONString("bar") ]))
            }

            it("should fail if its value transformation fails") {
                let result = valueTransformer.reverseTransform(.JSONString("foobar"))

                expect(result.value).to(beNil())
            }
        }
    }
}
