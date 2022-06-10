//
//  HomeViewController.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 10/06/2022.
//

import UIKit
protocol HomeViewProtocol: AnyObject {
}
class HomeViewController: UIViewController {
    @IBOutlet private weak var chooseCurrencyLabel: UILabel!
    @IBOutlet private weak var amountTextField: UITextField!
    
    lazy var presenter: HomePresenterProtocol? = {
        let presenter = HomePresenter(view: self)
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getAllCurrencies()
        presenter?.getLatestCurrencyUpdates()
    }
}

extension HomeViewController {
    @IBAction private func chooseCurrency() {
        if let currencies = presenter?.currencies {
            let currenciesViewController = CurrenciesViewController.create(with: currencies,
                                                                           delegate: self)
            present(currenciesViewController, animated: true)
            
        }
       
    }
}

extension HomeViewController: HomeViewProtocol {
   
}

extension HomeViewController: CurrencySelector {
    func didSelect(currnecy: String) {
        chooseCurrencyLabel.text = currnecy
    }
}


