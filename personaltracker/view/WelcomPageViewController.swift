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
    var onDismiss: () -> Void = { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSignal()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppear()
    }
    
    private func setupSignal() {
        nameTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe({ [weak self] _ in
                guard let `self` = self else { return }
                self.viewModel.onTextChange(text: self.nameTextField.nonNilText)
            }).disposed(by: disposeBag)
        
        goButton.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.viewModel.goTapped(name: self.nameTextField.nonNilText)
        }.disposed(by: disposeBag)
        
        viewModel.event.emit { [unowned self] event in
            switch(event) {
            case .goToMainPage:
                onDismiss()
                dismiss(animated: false)
                
                break
            case .enableGo(let isEnabled):
                self.goButton.alpha = isEnabled ? 1.0 : 0.3
                self.goButton.isEnabled = isEnabled
                break
            }
        }.disposed(by: disposeBag)
    }
}

