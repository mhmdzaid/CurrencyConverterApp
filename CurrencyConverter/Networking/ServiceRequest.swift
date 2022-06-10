//
//  ServiceRequest.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 10/06/2022.
//

import Foundation
import Alamofire
public enum ServiceRequest: String, URLRequestConvertible {
    case currencies
    case latest
    
    private var serviceAppID: String {
        return "f2cea6e8acba42a18605e5ec4bdc11d6"
    }
    
    var urlAsString: String {
        return "https://openexchangerates.org/api/\(self).json?app_id=\(serviceAppID)"
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = URL(string: urlAsString)
        let request = try URLRequest(url: url!, method: .get, headers: nil)
        return request
    }
}

