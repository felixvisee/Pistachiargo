//
//  JSONAdapter.swift
//  Pistachiargo
//
//  Created by Felix Jendrusch on 2/11/15.
//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.
//

import Result
import Monocle
import Pistachio
import Argo

public struct JSONAdapter<Value>: AdapterType {
    private typealias Adapter = DictionaryAdapter<String, Value, JSONValue, NSError>
    private let adapter: Adapter

    public init(specification: Adapter.Specification, valueClosure: JSONValue -> Result<Value, NSError>) {
        adapter = DictionaryAdapter(specification: specification, dictionaryTransformer: JSONValueTransformers.dictionary, valueClosure: valueClosure)
    }

    public init(specification: Adapter.Specification, @autoclosure(escaping) value: () -> Value) {
        adapter = DictionaryAdapter(specification: specification, dictionaryTransformer: JSONValueTransformers.dictionary, value: value)
    }

    public func transform(value: Value) -> Result<JSONValue, NSError> {
        return adapter.transform(value)
    }

    public func reverseTransform(transformedValue: JSONValue) -> Result<Value, NSError> {
        return adapter.reverseTransform(transformedValue)
    }
}
