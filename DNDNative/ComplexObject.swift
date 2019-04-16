//
//  ComplexObject.swift
//  DNDNative
//
//  Created by Ashley Ng on 4/16/19.
//  Copyright © 2019 AshleyNg. All rights reserved.
//

import Foundation
import MobileCoreServices

//@objcMembers
final class ComplexObject: NSObject, NSItemProviderReading, NSItemProviderWriting, Codable {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [kUTTypeText as String]
    }

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> ComplexObject {
        switch typeIdentifier {
        case kUTTypeText as NSString as String:
            guard let string = String(data: data, encoding: .utf8) else {
                return ComplexObject(name: "Unknown")
            }
            return ComplexObject(name: string)
        default:
            return ComplexObject(name: "Unknown")
        }
    }

    static var writableTypeIdentifiersForItemProvider: [String] {
        return [kUTTypePlainText as String]
    }

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        switch typeIdentifier {
        case kUTTypePlainText as NSString as String:
            completionHandler(loremIpsum.data(using: .utf8), nil)
        default:
            completionHandler(nil, nil)
        }
        return nil
    }

    let id: String
    let loremIpsum: String

    init(name: String) {
        self.id = UUID().uuidString
        self.loremIpsum = name

    }
}
