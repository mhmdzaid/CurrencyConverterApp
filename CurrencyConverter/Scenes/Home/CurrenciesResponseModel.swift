//
//  CurrenciesResponseModel.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 10/06/2022.
//

import Foundation

public struct CurrenciesResponseModel: Codable {
    let disclaimer: String?
    let license: String?
    let timestamp: Int?
    let base: String?
    let rates: [String: Double]?
}

public typealias AllCurrencies = [String: String]
