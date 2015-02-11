//
//  JSONAdapter.swift
//  Pistachiargo
//
//  Created by Felix Jendrusch on 2/11/15.
//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.
//

import LlamaKit
import Pistachio

import Argo

public struct JSONAdapter<Model>: Adapter {
    private let adapter: DictionaryAdapter<Model, JSONValue, NSError>

    public init(specification: [String: Lens<Result<Model, NSError>, Result<JSONValue, NSError>>]) {
        adapter = DictionaryAdapter(specification: specification, dictionaryTansformer: JSONValueTransformers.dictionary)
    }

    public func encode(model: Model) -> Result<JSONValue, NSError> {
        return adapter.encode(model)
    }

    public func decode(model: Model, from data: JSONValue) -> Result<Model, NSError> {
        return adapter.decode(model, from: data)
    }
}
