//
//  CurrencyViewController.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import UIKit

class CurrencyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sourceCurrencyNameLbl: UILabel!
    @IBOutlet weak var sourceCurrencySymbolLbl: UILabel!
    @IBOutlet weak var sourceRateTxtField: UITextField!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var topContainerView: UIView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let temp = UIRefreshControl()
        temp.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        return temp
    }()
    
    private lazy var loadingView: LoadingView = {
        let temp = LoadingView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    var presenter: CurrencyPresenterProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    //  MARK: Selectors.
    @objc func handleRefreshControl() {
        presenter?.refreshLiveCurrencies()
    }
    
    @objc func handleTappedView() {
        sourceRateTxtField.resignFirstResponder()
    }
    
    @objc func handleSourceRateTextFieldChanged() {
        let newValue = Double(sourceRateTxtField.text ?? "1")
        
        presenter?.changeSourceValue(to: newValue ?? 1)
    }
}

//  MARK: - Lifecycles.
extension CurrencyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        presenter?.viewDidLoad()
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
        tableView.contentInset = .init(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        tableView.estimatedSectionHeaderHeight = 24
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        sourceRateTxtField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [.foregroundColor: UIColor.s10!.withAlphaComponent(0.5)])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTappedView))
        view.addGestureRecognizer(tapGesture)
        
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        
        sourceRateTxtField.addTarget(self, action: #selector(handleSourceRateTextFieldChanged), for: UIControl.Event.editingChanged)
        
        view.addSubview(loadingView)
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func reloadPicker() {
        guard currencyPickerView.numberOfRows(inComponent: 0) == 0 else { return }
        
        currencyPickerView.reloadAllComponents()
        
        guard let selectedRow = presenter?.sourceCurrencyIndex else { return }
        
        currencyPickerView.selectRow(selectedRow, inComponent: 0, animated: false)
    }
    
    private func createTableHeaderView(for section: Int) -> UIView {
        let headerView = UIView()
        
        if #available(iOS 13.0, *) {
            headerView.backgroundColor = .systemBackground
        } else {
            headerView.backgroundColor = .white
        }
        
        let titleLbl = UILabel()
        titleLbl.font = UIFont.boldSystemFont(ofSize: 17)
        titleLbl.textColor = .c300
        titleLbl.text = "All exchange rates"
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLbl)
        titleLbl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        titleLbl.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16).isActive = true
        titleLbl.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16).isActive = true
        return headerView
    }
}

//  MARK: - PRESENTER -> VIEW
extension CurrencyViewController: CurrencyViewProtocol {
    func updateCurrencyList(deletions: [Int], insertions: [Int], modifications: [Int]) {
        reloadPicker()
        
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
    
    func updateSourceCurrencyUIs(isAnimate: Bool) {
        guard let data = presenter?.getSourceCurrencyDisplayData() else { return }
        
        sourceCurrencyNameLbl.text = data.currencyName
        sourceCurrencySymbolLbl.text = data.currencySymbol
        
        guard isAnimate else { return }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7) {[unowned self] in
            view.layoutIfNeeded()
        }
    }
    
    func endRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {[unowned self] in
            refreshControl.endRefreshing()
        }
    }
    
    func changeLoadingState(isLoading: Bool, isAnimate: Bool) {
        if isLoading {
            loadingView.startAnimation(isAnimate: isAnimate)
        } else {
            loadingView.stopAnimation(isAnimate: isAnimate)
        }
    }
    
    func gotError(error: CurrencyError) {
        presenter?.showError(view: self, error: error)
    }
}

//  MARK: - Picker datasources.
extension CurrencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter?.displayCurrencies.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let code = presenter?.displayCurrencies[row]
        
        let symbolView = CurrencySymbolView(frame: .init(x: 0, y: 0, width: 54, height: 54))
        symbolView.code = code ?? "USD"
        symbolView.backgroundColor = .primary
        
        return symbolView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectedCurrencyCode = presenter?.displayCurrencies[row] else { return }
        
        presenter?.changeSourceCurrency(with: selectedCurrencyCode)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 54
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 66
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createTableHeaderView(for: section)
    }
}
