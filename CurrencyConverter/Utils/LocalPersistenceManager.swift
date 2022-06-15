//
//  LocalPersistenceManager.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 15/06/2022.
//

import Foundation

protocol LocalPersistenceManagerProtocol {
    var nextTimeToRefresh: Date? { get set }
    func save(latestCurrencyRates: [String: Double])
    func save(currencies: AllCurrencies)
    func getAllRates() -> [String: Double]
    func getAllCurrencies() -> AllCurrencies
}
public class LocalPersistenceManager: LocalPersistenceManagerProtocol {
    
    var defaults: UserDefaultsProtocol
    
    var nextTimeToRefresh: Date? {
        set {
            defaults.set(value: newValue, key: "REFRESH_TIME")
        }
        
        get {
            defaults.getValue(forKey: "REFRESH_TIME") as? Date
        }
    }
    
    
    init(_ defaults: UserDefaultsProtocol! = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    func save(latestCurrencyRates: [String: Double]) {
        defaults.set(value: latestCurrencyRates, key: "RATES")
    }
    
    func save(currencies: AllCurrencies) {
        defaults.set(value: currencies, key: "CURRENCIES")
    }
    
    func getAllRates() -> [String: Double] {
        defaults.getValue(forKey: "RATES") as! [String : Double]
    }
    
    func getAllCurrencies() -> AllCurrencies {
        return defaults.getValue(forKey: "CURRENCIES") as! AllCurrencies
    }
}
