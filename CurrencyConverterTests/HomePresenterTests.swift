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
    var view: HomeViewSpy?
    var service: CurrencyConverterServiceMock<CurrenciesResponseModel>!
    
    override func setUp() {
        super.setUp()
        let model = CurrenciesResponseModel(disclaimer: "",
                                            license: "https://openexchangerates.org/license",
                                            timestamp: 1654880400,
                                            base: "USD", rates: ["EGP": 18.70,
                                                                 "USA": 1])
        
        service = CurrencyConverterServiceMock<CurrenciesResponseModel>(.success(model))
        view = HomeViewSpy()
        sut = HomePresenter(view: view, service: service)
    }
    
    func testGetAllCurrencies() {
        let model = [ "AED": "United Arab Emirates Dirham",
                      "AFN": "Afghan Afghani",
                      "ALL": "Albanian Lek",
                      "AMD": "Armenian Dram",
                      "ANG": "Netherlands Antillean Guilder",
                      "AOA": "Angolan Kwanza"]
        
        let allCurrenciesSerivce = CurrencyConverterServiceMock<[String: String]>(.success(model))
        view = HomeViewSpy()
        sut = HomePresenter(view: view, service: allCurrenciesSerivce)
        sut.getAllCurrencies()
        XCTAssertNotNil(sut.currencies)
        XCTAssertEqual(sut.currencies["AED"], "United Arab Emirates Dirham")
    }

    func testGetLatestCurrencyUpdates() {
        sut.getLatestCurrencyUpdates()
        XCTAssertFalse(view?.isShowLoadingCalled ?? true)
        
    }
    
    func testGetAllCurrencies_failure() {
        service = CurrencyConverterServiceMock<CurrenciesResponseModel>(.failure(.explicitlyCancelled))
        view = HomeViewSpy()
        sut = HomePresenter(view: view, service: service)
        sut.getAllCurrencies()
        XCTAssertTrue(view?.isShowingErrorOverlay ?? false )
    }
    
    func testUpdateCurrenciesList() {
        sut.getLatestCurrencyUpdates()
        sut.selectedBaseCurrency = "USA"
        sut.updateCurrenciesList(amount: 10)
        XCTAssertEqual(sut.numberOfListItems, 1)
    }
    
    func testGetCurrencyListItem() {
        sut.getLatestCurrencyUpdates()
        sut.selectedBaseCurrency = "USA"
        sut.updateCurrenciesList(amount: 1)
        let item = sut.getCurrencyListItem(at: 0)
        XCTAssertEqual(item, "EGP: 18.70")
    }
    
    override func tearDown() {
        view = nil
        service = nil
        sut = nil 
        super.tearDown()
    }
}

class CurrencyConverterServiceMock<ModelType: Decodable>: CurrencyConverterServiceProtocol {
    var result: Result<ModelType, AFError>
    init(_ result: Result<ModelType, AFError>) {
        self.result = result
    }
    
    
    func sendRequestWith<T>(endPoint: ServiceRequest,
                            model: T.Type,
                            completion: @escaping (Result<T, AFError>) -> Void) where T : Decodable {
        
        switch self.result {
        case .success(let model):
//            if model is CurrenciesResponseModel {
//                completion(.success( CurrenciesResponseModel(disclaimer: "",
//                                                             license: "https://openexchangerates.org/license",
//                                                             timestamp: 1654880400,
//                                                             base: "USD", rates: [:]) as! T ))
//            } else {
//                completion(.success(
//                    [ "AED": "United Arab Emirates Dirham",
//                      "AFN": "Afghan Afghani",
//                      "ALL": "Albanian Lek",
//                      "AMD": "Armenian Dram",
//                      "ANG": "Netherlands Antillean Guilder",
//                      "AOA": "Angolan Kwanza"] as! T
//                ))
//            }
            completion(.success(model as! T))
            
        case .failure(let error):
            completion(.failure(error))
        }
        
        
    }
}

class HomeViewSpy: HomeViewProtocol {
    var isShowingErrorOverlay = false
    var isShowLoadingCalled = false
    var isHideLoadingCalled = false
    var isViewRefreshed: Bool = false
    
    func refreshCurrenciesList() {
        isViewRefreshed = true
    }
    
    func showLoadingView() {
        isShowLoadingCalled = true
    }
    
    func hideLoadingView() {
        isHideLoadingCalled = true
    }
    
    func showErrorOverlay() {
        isShowingErrorOverlay = true
    }
}
