//
//  DashboardViewController.swift
//  personaltracker
//
//  Created by kur niadi  on 12/07/22.
//

import UIKit
import Charts
import RxSwift

class DashboardViewController: UIViewController {

    @IBOutlet var pieChartView: PieChartView!
    
    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var categoryButton: UIButton!
    @IBOutlet var amountButton: UIButton!
    
    @IBOutlet var endLabel: UILabel!
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var recordTableView: UITableView!
    @IBOutlet var barChatView: BarChartView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: DashboardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.setup()
        barChatView.setup()
        
        recordTableView.register(UINib(nibName: "RecordTableViewCell", bundle: .main), forCellReuseIdentifier: "RecordTableViewCell")
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        
        recordTableView.reloadData()
        
        setupSignal()
        
        viewModel.viewLoad()
    }
    
    private func setupSignal() {
        viewModel.event.emit { [weak self] event in
            guard let `self` = self else { return }
            switch(event) {
            case .updateGreetingLabel(let greeting):
                self.greetingLabel.text = greeting
                
            case .updateBarChart(let viewParams):
                self.barChatView.setDataBar(source: viewParams)
                
            case .updatePieChart(let viewParams):
                self.pieChartView.setDataCount(dataRaw: viewParams)
                
            case .showError(let message):
                self.showError(message: message)
                
            case .updateTable:
                self.recordTableView.reloadData()
                
            case .openPeriodeSelector(let periodes):
                let alert = UIAlertController(title: "Attention", message: "Pick A Periode", preferredStyle: .alert)
                periodes.forEach { param in
                    let action = UIAlertAction(title: param.formattedPeriode, style: .default) { [weak self] _ in
                        self?.viewModel.changePeriode(periode: param)
                    }
                    
                    alert.addAction(action)
                }
                
                let cancel = UIAlertAction(title: "Cancel", style: .destructive)
                alert.addAction(cancel)
                self.present(alert, animated: true)
                
            case .highlightDate:
                self.highlightDate()
                
            case .highlightName:
                self.highlightName()
                
            case .highlightCategory:
                self.highlightCategory()
                
            case .highlightAmount:
                self.highlightAmount()
            case .updateCalendarLabel(let start, let end):
                self.endLabel.text = end
                self.startLabel.text = start
            }
        }.disposed(by: disposeBag)

    }
    
    private func highlightDate() {
        dateButton.backgroundColor = UIColor.darkGray
        nameButton.backgroundColor = UIColor.clear
        amountButton.backgroundColor = UIColor.clear
        categoryButton.backgroundColor = UIColor.clear
    }

    private func highlightName() {
        nameButton.backgroundColor = UIColor.darkGray
        categoryButton.backgroundColor = UIColor.clear
        amountButton.backgroundColor = UIColor.clear
        dateButton.backgroundColor = UIColor.clear
    }
    
    private func highlightCategory() {
        categoryButton.backgroundColor = UIColor.darkGray
        nameButton.backgroundColor = UIColor.clear
        amountButton.backgroundColor = UIColor.clear
        dateButton.backgroundColor = UIColor.clear
    }
    
    private func highlightAmount() {
        amountButton.backgroundColor = UIColor.darkGray
        nameButton.backgroundColor = UIColor.clear
        dateButton.backgroundColor = UIColor.clear
        categoryButton.backgroundColor = UIColor.clear
    }
    
    @IBAction func sortByDateTap(_ sender: Any) {
        viewModel.toggleSortByDate()
    }
    
    @IBAction func sortByNameTap(_ sender: Any) {
        viewModel.toggleSortByName()
    }
    
    @IBAction func sortByCategoryTap(_ sender: Any) {
        viewModel.toggleSortByCategory()
    }
    
    @IBAction func sortByAmountTap(_ sender: Any) {
        viewModel.toggleSortByAmount()
    }
    
    @IBAction func calendarTap(_ sender: Any) {
        viewModel.calendarTap()
    }
    
    @IBAction func incomeButtonTap(_ sender: Any) {
        guard let income = UIStoryboard.createViewController(vc: AddDataViewController.self) else { return }
        income.type = .income
        income.onSuccess = { [weak self] in
            self?.viewModel.viewLoad()
        }
        
        present(income, animated: true)
    }
    
    @IBAction func expenseButtonTap(_ sender: Any) {
        guard let expense = UIStoryboard.createViewController(vc: AddDataViewController.self) else { return }
        expense.type = .expense
        expense.onSuccess = { [weak self] in
            self?.viewModel.viewLoad()
        }
        
        present(expense, animated: true)
    }
    
    @IBAction func tabChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            barChatView.isHidden = false
            pieChartView.isHidden = true
        } else {
            barChatView.isHidden = true
            pieChartView.isHidden = false
        }
    }
    
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recordCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as? RecordTableViewCell else {
            return UITableViewCell()
        }
        
        cell.set(item: viewModel.getItem(for: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
}

extension DashboardViewController: UITableViewDelegate { }
