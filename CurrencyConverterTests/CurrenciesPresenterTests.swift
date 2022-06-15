//
//  CurrenciesPresenterTests.swift
//  CurrencyConverterTests
//
//  Created by Mohamed Zead on 15/06/2022.
//

import XCTest
import Alamofire
@testable import CurrencyConverter
class CurrenciesPresenterTests: XCTestCase {
    var sut: CurrenciesPresenter!
    var view: CurrenciesViewSpy!
    var delegate: CurrencySelectorDelegateSpy!
    
    override func setUp() {
        super.setUp()
        view = CurrenciesViewSpy()
        delegate = CurrencySelectorDelegateSpy()
        sut = CurrenciesPresenter(view: view, delegate: delegate, currencies: [ "AED": "United Arab Emirates Dirham",
                                                                                "AFN": "Afghan Afghani",
                                                                                "ALL": "Albanian Lek",
                                                                                "AMD": "Armenian Dram",
                                                                                "ANG": "Netherlands Antillean Guilder",
                                                                                "AOA": "Angolan Kwanza"])
    }
    
    func testNumberOfCurrencies() {
        XCTAssertEqual(sut.numberOfCurrencies, 6)
    }
    
    func testLoadAllCurrencies() {
        sut.loadAllCurrencies()
        XCTAssertTrue(view.isLoadContentCalled)
    }
    
    func testGetCurrnecyForRow() {
        let currency = sut.getCurrnecyForRow(at: 0)
        let currencies = sut.currencies
        XCTAssertEqual(currency, currencies[0])
    }
    
    func testDidSelectCurrencyAtIndex() {
        let currencies = sut.currencies
        let currency = currencies[1]
        sut.didSelectCurrency(at: 1)
        XCTAssertEqual(delegate.selectedCurrency, currency.components(separatedBy: ":").first ?? "")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

class CurrencySelectorDelegateSpy: CurrencySelector {
    var selectedCurrency = ""
    
    func didSelect(currency: String) {
        self.selectedCurrency = currency
    }
}

class CurrenciesViewSpy: CurrenciesViewProtocol {
    var isLoadContentCalled = false
    
    func loadContent() {
        isLoadContentCalled = true
    }
    
    
}
