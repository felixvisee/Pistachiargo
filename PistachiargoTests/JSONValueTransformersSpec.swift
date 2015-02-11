//
//  JSONValueTransformerSpec.swift
//  Pistachiargo
//
//  Created by Felix Jendrusch on 2/11/15.
//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.
//

import Quick
import Nimble

import LlamaKit
import Pistachio

import Argo
import Pistachiargo

class JSONValueTransformersSpec: QuickSpec {
    override func spec() {
        describe("An NSNumber to JSON value transformer") {
            let valueTransformer = JSONValueTransformers.nsNumber

            it("should transform a value") {
                let result = valueTransformer.transformedValue(NSNumber(integer: 1))

                expect(result.value).to(equal(JSONValue.JSONNumber(1)))
            }

            it("should reverse transform a value") {
                let result = valueTransformer.reverseTransformedValue(.JSONNumber(2.5))

                expect(result.value).to(equal(NSNumber(float: 2.5)))
            }

            it("should fail if its value transformation fails") {
                let result = valueTransformer.reverseTransformedValue(.JSONString("3"))

                expect(result.isSuccess).to(beFalse())
            }
        }

        describe("A String to JSON value transformer") {
            let valueTransformer = JSONValueTransformers.string

            it("should transform a value") {
                let result = valueTransformer.transformedValue("foo")

                expect(result.value).to(equal(JSONValue.JSONString("foo")))
            }

            it("should reverse transform a value") {
                let result = valueTransformer.reverseTransformedValue(.JSONString("bar"))

                expect(result.value).to(equal("bar"))
            }

            it("should fail if its value transformation fails") {
                let result = valueTransformer.reverseTransformedValue(.JSONArray([ .JSONString("foobar") ]))

                expect(result.isSuccess).to(beFalse())
            }
        }

        describe("A Bool to JSON value transformer") {
            let valueTransformer = JSONValueTransformers.bool

            it("should transform a value") {
                let result = valueTransformer.transformedValue(true)

                expect(result.value).to(equal(JSONValue.JSONNumber(true)))
            }

            it("should reverse transform a value") {
                let result = valueTransformer.reverseTransformedValue(.JSONNumber(false))

                expect(result.value).to(equal(false))
            }

            it("should fail if its value transformation fails") {
                let result = valueTransformer.reverseTransformedValue(.JSONString("foobar"))

                expect(result.isSuccess).to(beFalse())
            }
        }

        describe("A [String: JSON] to JSON value transformer") {
            let valueTransformer = JSONValueTransformers.dictionary

            it("should transform a value") {
                let result = valueTransformer.transformedValue([ "foo": .JSONString("bar") ])

                expect(result.value).to(equal(JSONValue.JSONObject([ "foo": .JSONString("bar") ])))
            }

            it("should reverse transform a value") {
                let result = valueTransformer.reverseTransformedValue(.JSONObject([ "bar": .JSONString("foo") ]))

                expect(result.value).to(equal([ "bar": .JSONString("foo") ]))
            }

            it("should fail if its value transformation fails") {
                let result = valueTransformer.reverseTransformedValue(.JSONString("foobar"))

                expect(result.isSuccess).to(beFalse())
            }
        }

        describe("A [JSON] to JSON value transformer") {
            let valueTransformer = JSONValueTransformers.array

            it("should transform a value") {
                let result = valueTransformer.transformedValue([ .JSONString("foo") ])

                expect(result.value).to(equal(JSONValue.JSONArray([ .JSONString("foo") ])))
            }

            it("should reverse transform a value") {
                let result = valueTransformer.reverseTransformedValue(.JSONArray([ .JSONString("bar") ]))

                expect(result.value).to(equal([ .JSONString("bar") ]))
            }

            it("should fail if its value transformation fails") {
                let result = valueTransformer.reverseTransformedValue(.JSONString("foobar"))

                expect(result.isSuccess).to(beFalse())
            }
        }
    }
}
