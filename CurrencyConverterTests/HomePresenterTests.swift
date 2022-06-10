//
//  HomePresenterTests.swift
//  HomePresenterTests
//
//  Created by Mohamed Zead on 10/06/2022.
//

import XCTest
import Alamofire
@testable import CurrencyConverter
class HomePresenterTests: XCTestCase {
    var sut: HomePresenter!
    var service: CurrencyConverterServiceMock!
    
    override func setUp() {
        super.setUp()
        service = CurrencyConverterServiceMock()
        sut = HomePresenter(service: service)
    }
    
    func testGetAllCurrencies() {
        sut.getAllCurrencies()
        XCTAssertNotNil(sut.currencies)
        XCTAssertEqual(sut.currencies["AED"], "United Arab Emirates Dirham")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

class CurrencyConverterServiceMock: CurrencyConverterServiceProtocol {
    
    func sendRequestWith<T>(endPoint: ServiceRequest,
                            model: T.Type,
                            completion: @escaping (Result<T, AFError>) -> Void) where T : Decodable {
        if model == CurrenciesResponseModel.self {
            completion(.success( CurrenciesResponseModel(disclaimer: "",
                                                         license: "https://openexchangerates.org/license",
                                                         timestamp: 1654880400,
                                                         base: "USD", rates: [:]) as! T))
        } else {
            completion(.success(
                [ "AED": "United Arab Emirates Dirham",
                  "AFN": "Afghan Afghani",
                  "ALL": "Albanian Lek",
                  "AMD": "Armenian Dram",
                  "ANG": "Netherlands Antillean Guilder",
                  "AOA": "Angolan Kwanza"] as! T
            ))
            
            
        }
        
    }
}
