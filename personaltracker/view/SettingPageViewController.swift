//
//  SettingPageViewController.swift
//  personaltracker
//
//  Created by kur niadi  on 11/07/22.
//

import UIKit
import RxSwift

class SettingPageViewController: UIViewController {

    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var resetDayLabel: UILabel!
    
    var viewModel: SettingPageViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSignal()
        
        viewModel.viewLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func currencyTap(_ sender: Any) {
        viewModel.onCurrenncyTapped()
    }
    
    @IBAction func dayResetTap(_ sender: Any) {
        viewModel.onDayResetTapped()
    }
    
    private func setupSignal() {
        viewModel.event.emit { [unowned self] event in
            switch(event) {
            case .showError(let message):
                self.showError(message: message)
            case .showCurrencySelection(let items):
                self.showCurrencySelection(items: items)
            case .updateCurrency(let currency):
                self.currencyLabel.text = currency
            case .updateResetDay(let resetDay):
                self.resetDayLabel.text = resetDay
            case .showDayResetInput(let current):
                self.showDayResetInput(current: current)
            }
        }.disposed(by: disposeBag)
    }
    
    private func showDayResetInput(current: Int) {
        let alert = UIAlertController(title: "Attention", message: "Please input any day between 1 unt1l 31", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = current.description
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
            guard let textField = alert.textFields!.first
            else { return }
            
            let day = Int(textField.text ?? "0") ?? 0
            self.viewModel.onResetDaySelected(day: day)
            
        }))
        present(alert, animated: true)
    }
    
    private func showCurrencySelection(items: [String]) {
        let alert = UIAlertController(title: "Attention", message: "Choose your currency", preferredStyle: .alert)
       
        items.forEach { item in
            let action = UIAlertAction(title: item, style: .default) { [unowned self] _ in
                self.viewModel.onCurrencySelected(currency: item)
            }
            
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
