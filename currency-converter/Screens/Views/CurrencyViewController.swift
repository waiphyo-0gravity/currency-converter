//
//  CurrencyViewController.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit

class CurrencyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sourceCurrencySymbolView: CurrencySymbolView!
    @IBOutlet weak var sourceCurrencyNameLbl: UILabel!
    @IBOutlet weak var sourceCurrencySymbolLbl: UILabel!
    @IBOutlet weak var sourceRateTxtField: UITextField!
    
    private lazy var refreshControl: UIRefreshControl = {
        let temp = UIRefreshControl()
        temp.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        return temp
    }()
    
    var presenter: CurrencyPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        presenter?.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    //    MARK: Selectors
    @objc func handleRefreshControl() {
        presenter?.refreshLiveCurrencies()
    }
    
    @objc func handleTappedView() {
        sourceRateTxtField.resignFirstResponder()
    }
}

//  MARK: - Private functions
extension CurrencyViewController {
    private func initial() {
        tableView.addSubview(refreshControl)
        tableView.register(CurrencyTableViewCell.createNib(), forCellReuseIdentifier: CurrencyTableViewCell.CELL_IDENTIFIER)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        sourceCurrencySymbolView.font = .boldSystemFont(ofSize: 18)
        
        sourceRateTxtField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [.foregroundColor: UIColor.s10!.withAlphaComponent(0.5)])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTappedView))
        view.addGestureRecognizer(tapGesture)
    }
}

//  MARK: - PRESENTER -> VIEW
extension CurrencyViewController: CurrencyViewProtocol {
    func updateCurrencyList(deletions: [Int], insertions: [Int], modifications: [Int]) {
        if deletions.count == 0 && insertions.count == 0 && modifications.count == 0 {
            tableView.reloadData()
        } else {
            let deleteRows = deletions.map { IndexPath(row: $0, section: 0) }
            let insertRows = insertions.map { IndexPath(row: $0, section: 0) }
            let reloadRows = modifications.map { IndexPath(row: $0, section: 0) }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: deleteRows, with: .automatic)
            tableView.insertRows(at: insertRows, with: .automatic)
            tableView.reloadRows(at: reloadRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func updateSourceCurrencyUIs() {
        guard let data = presenter?.getSourceCurrencyDisplayData() else { return }
        
        sourceCurrencySymbolView.code = data.currencyCode
        sourceCurrencyNameLbl.text = data.currencyName
        sourceCurrencySymbolLbl.text = data.currencySymbol
    }
    
    func endRefreshControl() {
        guard refreshControl.isRefreshing else { return }
        
        refreshControl.endRefreshing()
    }
}

//  MARK: - Table view delegates & datasources.
extension CurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.displayCurrencies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.CELL_IDENTIFIER, for: indexPath) as? CurrencyTableViewCell else {
            return UITableViewCell()
        }
        
        let code = presenter?.displayCurrencies[indexPath.row]
        let displayData = presenter?.getCurrencyDisplayData(for: code)
        cell.setData(code: displayData?.currencyCode, currencyName: displayData?.currencyName, fomattedCurrencyRate: displayData?.exchangeRateStr)
        
        return cell
    }
}
