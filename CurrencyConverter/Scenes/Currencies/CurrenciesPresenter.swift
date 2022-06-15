//
//  CurrenciesPresenter.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 10/06/2022.
//

import Foundation
protocol CurrenciesPresenterProtocol {
    var numberOfCurrencies: Int { get }
    func loadAllCurrencies()
    func getCurrnecyForRow(at index: Int) -> String
    func didSelectCurrency(at index: Int)
}
public class CurrenciesPresenter: CurrenciesPresenterProtocol {
    private weak var view: CurrenciesViewProtocol?
    let currencies: [String]
    private var delegate: CurrencySelector?

    var numberOfCurrencies: Int {
        return currencies.count
    }
    
    init(view: CurrenciesViewProtocol?,
         delegate: CurrencySelector?,
         currencies: AllCurrencies) {
        self.view = view
        self.delegate = delegate
        self.currencies = currencies.map({ (key, value) in
            return "\(key): \(value)"
        })
    }
    
    func loadAllCurrencies() {
        view?.loadContent()
    }
    
    func getCurrnecyForRow(at index: Int) -> String {
        return currencies[index]
    }
    
    func didSelectCurrency(at index: Int) {
        let currency = getCurrnecyForRow(at: index)
        let currencyShortcut = currency.components(separatedBy: ":").first ?? ""
        delegate?.didSelect(currency: currencyShortcut)
    }
}
