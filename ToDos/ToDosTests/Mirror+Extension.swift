//
//  Mirror+Extension.swift
//  ToDosTests
//
//  Created by Дарья Саитова on 09.04.2026.
//

import Foundation

extension Mirror {
    static func reflectProperty<PropertyType>(from object: Any, name: String) -> PropertyType? {
        let mirror = Mirror(reflecting: object)
        for child in mirror.children {
            if child.label == name,
               let property = child.value as? PropertyType {
                return property
            }
        }
        return nil
    }
}
