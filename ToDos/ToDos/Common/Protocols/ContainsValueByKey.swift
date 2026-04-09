//
//  ReturnsValueByKey.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import Foundation

/// Протокол для закрытия `UserDefaults`.
protocol ContainsValueByKey: AnyObject {
    func bool(forKey key: String) -> Bool
    func set(_ value: Any?, forKey key: String)
}

extension UserDefaults: ContainsValueByKey { }

// MARK: Mock

final class ContainsValueByKeyMock: ContainsValueByKey {
    var boolWasCalled = 0
    var boolReceivedKey = ""
    var boolStub: Bool!
    
    func bool(forKey key: String) -> Bool {
        boolWasCalled += 1
        boolReceivedKey = key
        return boolStub
    }
    
    var setWasCalled = 0
    var setReceivedValue: Any?
    var setReceivedKey = ""
    
    func set(_ value: Any?, forKey key: String) {
        setWasCalled += 1
        setReceivedValue = value
        setReceivedKey = key
    }
}
