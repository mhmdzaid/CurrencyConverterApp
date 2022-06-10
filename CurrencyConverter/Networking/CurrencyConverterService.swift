//
//  CurrencyConverterService.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 10/06/2022.
//

import Foundation
import Alamofire

protocol CurrencyConverterServiceProtocol {
    func sendRequestWith<T: Decodable>(endPoint: ServiceRequest,
                                       model: T.Type,
                                       completion: @escaping (Result<T, AFError>) -> Void)
}

public class CurrencyConverterService: CurrencyConverterServiceProtocol {
    
    func sendRequestWith<T: Decodable>(endPoint: ServiceRequest,
                                       model: T.Type,
                                       completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(endPoint).response { response in
            
            if let responseData = response.data,
               let model = JSONParser<T>().parse(responseData) {
                
                completion(.success(model))
                
            } else {
                
                if let error = response.error {
                    completion(.failure(error))
                }
                
            }
        }.resume()
    }
    
}
