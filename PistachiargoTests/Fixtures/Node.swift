//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Monocle
import Pistachio
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
    static let children = Lens(get: { $0.children }, set: { (inout node: Node, children) in
        node.children = children
    })
}

struct NodeAdapters {
    static let json = fix { adapter in
        return JSONAdapter(specification: [
            "children": JSONArray(NodeLenses.children)(adapter: adapter)
        ], value: Node(children: []))
    }
}
