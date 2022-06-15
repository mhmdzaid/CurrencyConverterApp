//
//  UserDefaults + Extension.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 15/06/2022.
//

import Foundation

protocol UserDefaultsProtocol {
    func set(value: Any?, key: String)
    func getValue(forKey key: String) -> Any?
}

extension UserDefaults: UserDefaultsProtocol {
    func set(value: Any?, key: String) {
        setValue(value, forKey: key)
    }
    
    func getValue(forKey key: String) -> Any? {
        return value(forKey: key)
    }
}
