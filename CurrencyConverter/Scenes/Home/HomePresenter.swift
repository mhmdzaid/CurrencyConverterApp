//
//  HomePresenter.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 10/06/2022.
//

import Foundation
public protocol HomePresenterProtocol {
    var currencies: AllCurrencies { get set }
    func getAllCurrencies()
    func getLatestCurrencyUpdates()
}

public class HomePresenter: HomePresenterProtocol {
    private var service: CurrencyConverterServiceProtocol?
    private weak var view: HomeViewProtocol?
    public var currencies: AllCurrencies = [:]
    
    init(view: HomeViewProtocol? = nil, service: CurrencyConverterServiceProtocol? = CurrencyConverterService()) {
        self.service = service
        self.view = view
    }
    
    public func getAllCurrencies() {
        service?.sendRequestWith(endPoint: .currencies,
                                 model: AllCurrencies.self,
                                 completion: { [weak self] result  in
            
            switch result {
            case .success(let model):
                self?.currencies = model
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    public func getLatestCurrencyUpdates() {
        service?.sendRequestWith(endPoint: .latest,
                                 model: CurrenciesResponseModel.self) { result in
            switch result {
            case .success(let model):
                print(model.disclaimer ?? "")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
