//
//  HomePresenter.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 10/06/2022.
//

import Foundation
public protocol HomePresenterProtocol {
    var currencies: AllCurrencies { get set }
    var selectedBaseCurrency: String { get set }
    var numberOfListItems: Int { get }
    func getAllCurrencies()
    func getLatestCurrencyUpdates()
    func updateCurrenciesList(amount: Double)
    func getCurrencyListItem(at index: Int) -> String
    func fetchAll()
}

public class HomePresenter: HomePresenterProtocol {
    private var dispatchGroup: DispatchGroup?
    private var storageManager: LocalPersistenceManagerProtocol?
    private var service: CurrencyConverterServiceProtocol?
    private weak var view: HomeViewProtocol?
    private var listElements: [String] = []
    private var latestCurrencyValuesDict: [String: Double] = [:]
    public var currencies: AllCurrencies = [:]
    public var selectedBaseCurrency : String = ""
    public var numberOfListItems: Int {
        return listElements.count
    }
    
    init(view: HomeViewProtocol?,
         service: CurrencyConverterServiceProtocol? = CurrencyConverterService(),
         storageManager: LocalPersistenceManagerProtocol? = LocalPersistenceManager()) {
        self.service = service
        self.view = view
        self.storageManager = storageManager
        dispatchGroup = DispatchGroup()
        dispatchGroup?.notify(queue: .main, execute: { [weak self] in
            self?.view?.hideLoadingView()
            self?.storageManager?.nextTimeToRefresh = Date.now.addingTimeInterval(1800) // capture time stamp for next refresh time
        })
    }
    
    public func fetchAll() {
        guard let nextTimeToRefresh = storageManager?.nextTimeToRefresh, nextTimeToRefresh > Date.now else {
            // Get data from API
            getAllCurrencies()
            getLatestCurrencyUpdates()
            return
        }
        // Get data from local storage
        currencies = storageManager?.getAllCurrencies() ?? [:]
        latestCurrencyValuesDict = storageManager?.getAllRates() ?? [:]
    }
    
    public func getAllCurrencies() {
        view?.showLoadingView()
        dispatchGroup?.enter()
        self.service?.sendRequestWith(endPoint: .currencies,
                                      model: AllCurrencies.self,
                                      completion: { [weak self] result  in
            
            switch result {
            case .success(let model):
                self?.currencies = model
                self?.storageManager?.save(currencies: self?.currencies ?? [:])
                
            case .failure:
                self?.view?.showErrorOverlay()
            }
            self?.dispatchGroup?.leave()
        })
    }
    
    public func getLatestCurrencyUpdates() {
        dispatchGroup?.enter()
        self.service?.sendRequestWith(endPoint: .latest,
                                      model: CurrenciesResponseModel.self) {[weak self] result in
            switch result {
            case .success(let model):
                self?.latestCurrencyValuesDict = model.rates ?? [:]
                self?.storageManager?.save(latestCurrencyRates: self?.latestCurrencyValuesDict ?? [:])
                
            case .failure:
                self?.view?.showErrorOverlay()
            }
            self?.dispatchGroup?.leave()
        }
    }
    
    public func updateCurrenciesList(amount: Double) {
        listElements = []
        guard !selectedBaseCurrency.isEmpty,amount != 0 else {
            return
        }
        let valueForSelectedCurrency = latestCurrencyValuesDict[selectedBaseCurrency] ?? 0.0
        latestCurrencyValuesDict.forEach { (key, value) in
            if key != selectedBaseCurrency {
                let convertedValue = (value / valueForSelectedCurrency) * amount
                let convertedValueFormattedString = String(format: "%0.2f", arguments: [convertedValue])
                self.listElements.append("\(key): \(convertedValueFormattedString)")
            }
        }
        view?.refreshCurrenciesList()
    }
    
    public func getCurrencyListItem(at index: Int) -> String {
        return listElements[index]
    }
}
