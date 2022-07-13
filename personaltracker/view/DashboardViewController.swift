//
//  DashboardViewController.swift
//  personaltracker
//
//  Created by kur niadi  on 12/07/22.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {

    @IBOutlet var pieChartView: PieChartView!
    
    @IBOutlet var recordTableView: UITableView!
    @IBOutlet var barChatView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.setup()
        barChatView.setup(day: [6,7,8,9,1,2,3,4,5])
        
        pieChartView.setDataCount(date: [1,2,3,4,5,6,7,8,9])
        barChatView.setDataBar(source: [6,7,8,9,1,2,3,4,5])
        
        recordTableView.register(UINib(nibName: "RecordTableViewCell", bundle: .main), forCellReuseIdentifier: "RecordTableViewCell")
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        
        recordTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func incomeButtonTap(_ sender: Any) {
        guard let income = UIStoryboard.createViewController(vc: AddDataViewController.self) else { return }
        income.type = .income
        
        present(income, animated: true)
    }
    
    @IBAction func expenseButtonTap(_ sender: Any) {
        guard let expense = UIStoryboard.createViewController(vc: AddDataViewController.self) else { return }
        expense.type = .expense
        
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
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as? RecordTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
}


extension DashboardViewController: UITableViewDelegate {
    
}
