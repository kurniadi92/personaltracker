//
//  DashboardViewController.swift
//  personaltracker
//
//  Created by kur niadi  on 12/07/22.
//

import UIKit

extension UIStoryboard {
    static func createViewController<T: UIViewController>(vc: T.Type) -> T? {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: vc.self)) as? T
        
        return newViewController
    }
}

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
