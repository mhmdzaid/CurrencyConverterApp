//
//  CurrenciesViewController.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 10/06/2022.
//

import UIKit
protocol CurrenciesViewProtocol: AnyObject {
    func loadContent()
}
protocol CurrencySelector {
    func didSelect(currency: String)
}
class CurrenciesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    var presenter: CurrenciesPresenterProtocol?
    
    static func create(with currencies: AllCurrencies, delegate: CurrencySelector) -> CurrenciesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CurrenciesViewController") as! CurrenciesViewController
        viewController.presenter = CurrenciesPresenter(view: viewController,
                                                       delegate: delegate,
                                                       currencies: currencies)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    


}

extension CurrenciesViewController: CurrenciesViewProtocol {
    func loadContent() {
        tableView.reloadData()
    }
}

extension CurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfCurrencies ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = presenter?.getCurrnecyForRow(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectCurrency(at: indexPath.row)
        dismiss(animated: true)
    }
}
