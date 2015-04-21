//  Copyright (c) 2015 Felix Jendrusch. All rights reserved.

import Result
import ValueTransformer
import Monocle
import Pistachio
import Argo

public let ErrorDomain = "PistachiargoErrorDomain"
public let ErrorInvalidInput = 1

public struct JSONValueTransformers {
    public static let nsNumber: ReversibleValueTransformer<NSNumber, JSONValue, NSError> = ReversibleValueTransformer(transformClosure: { value in
        return Result.success(.JSONNumber(value))
    }, reverseTransformClosure: { transformedValue in
        switch transformedValue {
        case let .JSONNumber(value):
            return Result.success(value)
        default:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("Could not transform JSONValue to NSNumber", comment: ""),
                NSLocalizedFailureReasonErrorKey: String(format: NSLocalizedString("Expected a .JSONNumber, got: %@.", comment: ""), transformedValue.description)
            ]

            return Result.failure(NSError(domain: ErrorDomain, code: ErrorInvalidInput, userInfo: userInfo))
        }
    })

    public static func number() -> ReversibleValueTransformer<Int8, JSONValue, NSError> {
        return NSNumberValueTransformers.char() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<UInt8, JSONValue, NSError> {
        return NSNumberValueTransformers.unsignedChar() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<Int16, JSONValue, NSError> {
        return NSNumberValueTransformers.short() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<UInt16, JSONValue, NSError> {
        return NSNumberValueTransformers.unsignedShort() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<Int32, JSONValue, NSError> {
        return NSNumberValueTransformers.int() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<UInt32, JSONValue, NSError> {
        return NSNumberValueTransformers.unsignedInt() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<Int, JSONValue, NSError> {
        return NSNumberValueTransformers.long() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<UInt, JSONValue, NSError> {
        return NSNumberValueTransformers.unsignedLong() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<Int64, JSONValue, NSError> {
        return NSNumberValueTransformers.longLong() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<UInt64, JSONValue, NSError> {
        return NSNumberValueTransformers.unsignedLongLong() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<Float, JSONValue, NSError> {
        return NSNumberValueTransformers.float() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<Double, JSONValue, NSError> {
        return NSNumberValueTransformers.double() >>> nsNumber
    }

    public static func number() -> ReversibleValueTransformer<Bool, JSONValue, NSError> {
        return NSNumberValueTransformers.bool() >>> nsNumber
    }

    public static let bool: ReversibleValueTransformer<Bool, JSONValue, NSError> = ReversibleValueTransformer(transformClosure: { value in
        return Result.success(.JSONNumber(value))
    }, reverseTransformClosure: { transformedValue in
        switch transformedValue {
        case let .JSONNumber(value):
            return Result.success(value.boolValue)
        default:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("Could not transform JSONValue to Bool", comment: ""),
                NSLocalizedFailureReasonErrorKey: String(format: NSLocalizedString("Expected a .JSONNumber, got: %@.", comment: ""), transformedValue.description)
            ]

            return Result.failure(NSError(domain: ErrorDomain, code: ErrorInvalidInput, userInfo: userInfo))
        }
    })

    public static let string: ReversibleValueTransformer<String, JSONValue, NSError> = ReversibleValueTransformer(transformClosure: { value in
        return Result.success(.JSONString(value))
    }, reverseTransformClosure: { transformedValue in
        switch transformedValue {
        case let .JSONString(value):
            return Result.success(value)
        default:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("Could not transform JSONValue to String", comment: ""),
                NSLocalizedFailureReasonErrorKey: String(format: NSLocalizedString("Expected a .JSONString, got: %@.", comment: ""), transformedValue.description)
            ]

            return Result.failure(NSError(domain: ErrorDomain, code: ErrorInvalidInput, userInfo: userInfo))
        }
    })

    public static let dictionary: ReversibleValueTransformer<[String: JSONValue], JSONValue, NSError> = ReversibleValueTransformer(transformClosure: { value in
        return Result.success(.JSONObject(value))
    }, reverseTransformClosure: { transformedValue in
        switch transformedValue {
        case let .JSONObject(value):
            return Result.success(value)
        default:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("Could not transform JSONValue to [String: JSONValue]", comment: ""),
                NSLocalizedFailureReasonErrorKey: String(format: NSLocalizedString("Expected a .JSONObject, got: %@.", comment: ""), transformedValue.description)
            ]

            return Result.failure(NSError(domain: ErrorDomain, code: ErrorInvalidInput, userInfo: userInfo))
        }
    })

    public static let array: ReversibleValueTransformer<[JSONValue], JSONValue, NSError> = ReversibleValueTransformer(transformClosure: { value in
        return Result.success(.JSONArray(value))
    }, reverseTransformClosure: { transformedValue in
        switch transformedValue {
        case let .JSONArray(value):
            return Result.success(value)
        default:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString("Could not transform JSONValue to [JSONValue]", comment: ""),
                NSLocalizedFailureReasonErrorKey: String(format: NSLocalizedString("Expected a .JSONArray, got: %@.", comment: ""), transformedValue.description)
            ]

            return Result.failure(NSError(domain: ErrorDomain, code: ErrorInvalidInput, userInfo: userInfo))
        }
    })
}

public func JSONNumber<A>(lens: Lens<A, Int8>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Int8?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, UInt8>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, UInt8?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Int16>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Int16?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, UInt16>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, UInt16?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Int32>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Int32?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, UInt32>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, UInt32?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Int>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Int?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, UInt>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, UInt?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Int64>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Int64?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, UInt64>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, UInt64?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Float>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Float?>, defaultTransformedValue: JSONValue = .JSONNumber(0.0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Double>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Double?>, defaultTransformedValue: JSONValue = .JSONNumber(0.0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONNumber<A>(lens: Lens<A, Bool>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.number())
}

public func JSONNumber<A>(lens: Lens<A, Bool?>, defaultTransformedValue: JSONValue = .JSONNumber(0)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.number(), defaultTransformedValue: defaultTransformedValue))
}

public func JSONBool<A>(lens: Lens<A, Bool>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.bool)
}

public func JSONBool<A>(lens: Lens<A, Bool?>, defaultTransformedValue: JSONValue = .JSONNumber(false)) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.bool, defaultTransformedValue: defaultTransformedValue))
}

public func JSONString<A>(lens: Lens<A, String>) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, JSONValueTransformers.string)
}

public func JSONString<A>(lens: Lens<A, String?>, defaultTransformedValue: JSONValue = .JSONString("")) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(JSONValueTransformers.string, defaultTransformedValue: defaultTransformedValue))
}

public func JSONObject<A, T: AdapterType where T.TransformedValueType == JSONValue, T.ErrorType == NSError>(lens: Lens<A, T.ValueType>)(adapter: T) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, adapter)
}

public func JSONObject<A, T: AdapterType where T.TransformedValueType == JSONValue, T.ErrorType == NSError>(lens: Lens<A, T.ValueType?>, defaultTransformedValue: JSONValue = .JSONNull)(adapter: T) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(adapter, defaultTransformedValue: defaultTransformedValue))
}

public func JSONArray<A, T: AdapterType where T.TransformedValueType == JSONValue, T.ErrorType == NSError>(lens: Lens<A, [T.ValueType]>)(adapter: T) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(adapter) >>> JSONValueTransformers.array)
}

public func JSONArray<A, T: AdapterType where T.TransformedValueType == JSONValue, T.ErrorType == NSError>(lens: Lens<A, [T.ValueType]?>, defaultTransformedValue: JSONValue = .JSONNull)(adapter: T) -> Lens<Result<A, NSError>, Result<JSONValue, NSError>> {
    return map(lens, lift(lift(adapter) >>> JSONValueTransformers.array, defaultTransformedValue: defaultTransformedValue))
}
