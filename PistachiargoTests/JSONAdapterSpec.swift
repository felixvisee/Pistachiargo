//
//  JSONAdapterSpec.swift
//  Pistachiargo
//
//  Created by Felix Jendrusch on 2/11/15.
//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.
//

import Quick
import Nimble

import Result
import Monocle
import Pistachio
import Argo
import Pistachiargo

struct Node: Equatable {
    var children: [Node]

    init(children: [Node]) {
        self.children = children
    }
}

func == (lhs: Node, rhs: Node) -> Bool {
    return lhs.children == rhs.children
}

struct NodeLenses {
    static let children = Lens<Node, [Node]>(get: { $0.children }, set: { (inout node: Node, children) in
        node.children = children
    })
}

struct JSONAdapters {
    static let node: JSONAdapter<Node> = fix { adapter in
        return JSONAdapter(specification: [
            "children": JSONArray(NodeLenses.children)(adapter: adapter)
        ], value: Node(children: []))
    }
}

class JSONAdapterSpec: QuickSpec {
    override func spec() {
        describe("A JSONAdapter") {
            let adapter = JSONAdapters.node
            let json: JSONValue = .JSONObject([
                "children": .JSONArray([
                    .JSONObject([ "children": .JSONArray([]) ]),
                    .JSONObject([ "children": .JSONArray([]) ])
                ])
            ])

            it("should encode a model") {
                let result = adapter.transform(Node(children: [ Node(children: []), Node(children: []) ]))

                expect(result.value).to(equal(json))
            }

            it("should decode a model from data") {
                let result = adapter.reverseTransform(json)

                expect(result.value).to(equal(Node(children: [ Node(children: []), Node(children: []) ])))
            }
        }
    }
}
