//
//  HomeViewController.swift
//  CurrencyConverter
//
//  Created by Mohamed Zead on 10/06/2022.
//

import UIKit
protocol HomeViewProtocol: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func showErrorOverlay()
    func refreshCurrenciesList()
}
class HomeViewController: UIViewController {
    @IBOutlet private weak var chooseCurrencyLabel: UILabel!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.backgroundColor = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.layer.cornerRadius = 6
        return activityIndicator
    }()
    
    lazy var presenter: HomePresenterProtocol? = {
        let presenter = HomePresenter(view: self)
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        setUpActivityIndicator()
        presenter?.getAllCurrencies()
        presenter?.getLatestCurrencyUpdates()
    }
    
    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
    func showErrorOverlay() {
        // show Error overlay here 
    }
    
    func showLoadingView() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingView() {
        activityIndicator.stopAnimating()
    }
    
    func refreshCurrenciesList() {
        tableView.reloadData()
    }
    
   
}

extension HomeViewController: CurrencySelector {
    func didSelect(currency: String) {
        chooseCurrencyLabel.text = currency
        let amount = Double(amountTextField.text ?? "") ?? 0.0
        presenter?.selectedBaseCurrency = currency
        presenter?.updateCurrenciesList(amount: amount)
    }
}


// MARK:- HomeViewController + UITableViewDataSource

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfListItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = presenter?.getCurrencyListItem(at: indexPath.row) ?? ""
        return cell
    }
}


// MARK:- HomeViewController + UITextFieldDelegate

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedTextFieldContent = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let toDouble = Double(updatedTextFieldContent ?? "") ?? 0.0
        presenter?.updateCurrenciesList(amount: toDouble)
        return true
    }
}
