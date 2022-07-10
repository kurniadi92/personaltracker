//
//  ViewController.swift
//  personaltracker
//
//  Created by kur niadi  on 10/07/22.
//

import UIKit
import RxSwift

extension UITextField {
    var nonNilText: String {
        return text ?? ""
    }
}

class WelcomPageViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var goButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: WelcomePageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        setupSignal()
        
        viewModel.viewLoad()
    }
    
    private func setupSignal() {
        nameTextField.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                self.viewModel.onTextChange(text: nameTextField.nonNilText)
            }).disposed(by: disposeBag)
        
        goButton.rx.tap.subscribe { [unowned self] _ in
            self.viewModel.goTapped(name: self.nameTextField.nonNilText)
        }.disposed(by: disposeBag)
        
        viewModel.event.emit { [unowned self] event in
            switch(event) {
            case .goToMainPage:
                //
                break
            case .enableGo(let isEnabled):
                self.goButton.alpha = isEnabled ? 1.0 : 0.3
                self.goButton.isEnabled = isEnabled
                break
            }
        }.disposed(by: disposeBag)
    }
}

