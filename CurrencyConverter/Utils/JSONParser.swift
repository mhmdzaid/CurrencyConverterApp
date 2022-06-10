//
//  JSONParser.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 10/06/2022.
//

import Foundation

public class JSONParser<T: Decodable> {
    func parse(_ data: Data) -> T? {
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch let error {
            print("\(error.localizedDescription)")
        }
        return nil
    }
}
