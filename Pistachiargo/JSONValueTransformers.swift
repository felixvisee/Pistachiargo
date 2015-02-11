//
//  JSONValueTransformers.swift
//  Pistachiargo
//
//  Created by Felix Jendrusch on 2/11/15.
//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.
//

import LlamaKit
import Pistachio

import Argo

public let ErrorDomain = "PistachiargoErrorDomain"
public let ErrorInvalidInput = 1

public struct JSONValueTransformers {
    public static let nsNumber: ValueTransformer<NSNumber, JSONValue, NSError> = ValueTransformer(transformClosure: { value in
        return success(.JSONNumber(value))
    }, reverseTransformClosure: { value in
        switch value {
        case .JSONNumber(let value):
            return success(value)
        default:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("Could not decode number from JSON", comment: ""),
                NSLocalizedFailureReasonErrorKey: String(format: NSLocalizedString("Expected a JSON number, got: %@.", comment: ""), value.description)
            ]

            return failure(NSError(domain: ErrorDomain, code: ErrorInvalidInput, userInfo: userInfo))
        }
    })

    public static func number() -> ValueTransformer<Int8, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.char()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<UInt8, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.unsignedChar()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<Int16, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.short()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<UInt16, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.unsignedShort()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<Int32, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.int()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<UInt32, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.unsignedInt()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<Int, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.long()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<UInt, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.unsignedLong()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<Int64, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.longLong()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<UInt64, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.unsignedLongLong()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<Float, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.float()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<Double, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.double()) >>> nsNumber
    }

    public static func number() -> ValueTransformer<Bool, JSONValue, NSError> {
        return flip(NSNumberValueTransformers.bool()) >>> nsNumber
    }

    public static let string: ValueTransformer<String, JSONValue, NSError> = ValueTransformer(transformClosure: { value in
        return success(.JSONString(value))
    }, reverseTransformClosure: { value in
        switch value {
        case .JSONString(let value):
            return success(value)
        default:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("Could not decode string from JSON", comment: ""),
                NSLocalizedFailureReasonErrorKey: String(format: NSLocalizedString("Expected a JSON string, got: %@.", comment: ""), value.description)
            ]

            return failure(NSError(domain: ErrorDomain, code: ErrorInvalidInput, userInfo: userInfo))
        }
    })

    public static let bool: ValueTransformer<Bool, JSONValue, NSError> = ValueTransformer(transformClosure: { value in
        return success(.JSONNumber(value))
    }, reverseTransformClosure: { value in
        switch value {
        case .JSONNumber(let value):
            return success(value.boolValue)
        default:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("Could not decode bool from JSON", comment: ""),
                NSLocalizedFailureReasonErrorKey: String(format: NSLocalizedString("Expected a JSON bool, got: %@.", comment: ""), value.description)
            ]

            return failure(NSError(domain: ErrorDomain, code: ErrorInvalidInput, userInfo: userInfo))
        }
    })

    public static let dictionary: ValueTransformer<[String: JSONValue], JSONValue, NSError> = ValueTransformer(transformClosure: { value in
        return success(.JSONObject(value))
    }, reverseTransformClosure: { value in
        switch value {
        case .JSONObject(let value):
            return success(value)
        default:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("Could not decode dictionary from JSON", comment: ""),
                NSLocalizedFailureReasonErrorKey: String(format: NSLocalizedString("Expected a JSON dictionary, got: %@.", comment: ""), value.description)
            ]

            return failure(NSError(domain: ErrorDomain, code: ErrorInvalidInput, userInfo: userInfo))
        }
    })

    public static let array: ValueTransformer<[JSONValue], JSONValue, NSError> = ValueTransformer(transformClosure: { value in
        return success(.JSONArray(value))
    }, reverseTransformClosure: { value in
        switch value {
        case .JSONArray(let value):
            return success(value)
        default:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("Could not decode array from JSON", comment: ""),
                NSLocalizedFailureReasonErrorKey: String(format: NSLocalizedString("Expected a JSON array, got: %@.", comment: ""), value.description)
            ]

            return failure(NSError(domain: ErrorDomain, code: ErrorInvalidInput, userInfo: userInfo))
        }
    })
}

public func JSONNumber<A>(lens: Lens<A, Int8>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Int8?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, UInt8>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, UInt8?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Int16>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Int16?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, UInt16>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, UInt16?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Int32>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Int32?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, UInt32>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, UInt32?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Int>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Int?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, UInt>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, UInt?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Int64>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Int64?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, UInt64>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, UInt64?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Float>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Float?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0.0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Double>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Double?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0.0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Bool>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Bool?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.number(), defaultTransformedValue))
}

public func JSONString<A>(lens: Lens<A, String>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.string)
}

public func JSONString<A>(lens: Lens<A, String?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONString("")) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.string, defaultTransformedValue))
}

public func JSONBool<A>(lens: Lens<A, Bool>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, JSONValueTransformers.bool)
}

public func JSONBool<A>(lens: Lens<A, Bool?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNumber(false)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(JSONValueTransformers.bool, defaultTransformedValue))
}

public func JSONObject<A, B, T: Adapter where T.Model == B, T.Data == JSONValue, T.Error == NSError>(lens: Lens<A, B>)(adapter: T, model: @autoclosure () -> B) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(adapter, model))
}

public func JSONObject<A, B, T: Adapter where T.Model == B, T.Data == JSONValue, T.Error == NSError>(lens: Lens<A, B?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNull)(adapter: T, model: @autoclosure () -> B) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(lift(adapter, model), defaultTransformedValue))
}

public func JSONArray<A, B, T: Adapter where T.Model == B, T.Data == JSONValue, T.Error == NSError>(lens: Lens<A, [B]>)(adapter: T, model: @autoclosure () -> B) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(lift(adapter, model)) >>> JSONValueTransformers.array)
}

public func JSONArray<A, B, T: Adapter where T.Model == B, T.Data == JSONValue, T.Error == NSError>(lens: Lens<A, [B]?>, defaultTransformedValue: @autoclosure () -> JSONValue = .JSONNull)(adapter: T, model: @autoclosure () -> B) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return transform(lens, lift(lift(lift(adapter, model)) >>> JSONValueTransformers.array, defaultTransformedValue))
}
