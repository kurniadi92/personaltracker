//
//  AddDataViewController.swift
//  personaltracker
//
//  Created by kur niadi  on 11/07/22.
//

import UIKit
import RxSwift

class AddDataViewController: UIViewController {
    
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var categoryCollectionView: UICollectionView!
    private let imagePickerHelper = ImagePickerHelper()
    @IBOutlet var imageView: UIImageView!
    
    var viewModel: AddRecordViewModel!
    var type: RecordType = .expense
    var action: Action = .add
    var onSuccess: () -> Void = { }
    
    @IBOutlet var deleteButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        categoryCollectionView.delegate =  self
        categoryCollectionView.dataSource =  self
        categoryCollectionView.collectionViewLayout = LeftAlignedLayout()
        categoryCollectionView.reloadData()
        
        setupSignal()
        
        viewModel.viewLoad(type: type, action: action)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onViewTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func onViewTap()  {
        view.endEditing(true)
    }
    
    @IBAction func addTap(_ sender: Any) {
        viewModel.save(title: titleTextField.text, amount: Int(amountTextField.text ?? "") ?? 0)
    }
    
    private func setupSignal() {
        viewModel.event.emit { [weak self] event in
            guard let `self` = self else { return }
            switch(event) {
            case .setExpenseAppeareance:
                self.addButton.backgroundColor = UIColor.red
                self.addButton.setTitle("Add Expense", for: .normal)
            case .setIncomeAppeareance:
                self.addButton.backgroundColor = UIColor.green
                self.addButton.setTitle("Add Income", for: .normal)
            case .updateCategory:
                self.categoryCollectionView.reloadData()
            case .showSuccess:
                self.onSuccess()
                self.dismiss(animated: true)
            case .showError(let message):
                self.showError(message: message)
            case .setEditAppeareance(let viewParam):
                self.deleteButton.isHidden = false
                self.titleTextField.text = viewParam.title
                self.amountTextField.text = viewParam.amount.description
                guard let image = UIImage().fetchImage(with: viewParam.imageId) else {
                    return
                }
                self.setImageView(image: image)
            case .showDeleteConfirmation:
                let alert = UIAlertController(title: "Attention", message: "Do you want to delete this ?", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .destructive) { [weak self] _  in
                    self?.viewModel.confirmDelete()
                }
                
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(action)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
    @IBAction func deleteButtoTap(_ sender: Any) {
        viewModel.tapDelete()
    }
    
    private func setImageView(image: UIImage) {
        guard let url = image.saveToDocuments(filename: Int(Date().timeIntervalSince1970).description) else {
            return
        }
        imageView.image = try! UIImage(data: Data(contentsOf: url))
        viewModel.setImage(url: url)
    }
    
    @IBAction func imageTap(_ sender: Any) {
        imagePickerHelper.getImage(root: self) { [weak self] validImage in
            guard let url = validImage.saveToDocuments(filename: Int(Date().timeIntervalSince1970).description) else {
                return
            }
            self?.imageView.image = try! UIImage(data: Data(contentsOf: url))
            self?.viewModel.setImage(url: url)
        }
    }
    
    @IBAction func dismissTap(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension AddDataViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.itemSize(index: indexPath.row)
    }
}

extension AddDataViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectCategory(index: indexPath.row)
    }
}

extension AddDataViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return  UICollectionViewCell() }
        
        cell.setText(param: viewModel.category(index: indexPath.row))
        
        return cell
    }
}

private class LeftAlignedLayout: UICollectionViewFlowLayout {
    
    required override init() {super.init(); common()}
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder); common()}
    
    private func common() {
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }
    
    override func layoutAttributesForElements(
                    in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let att = super.layoutAttributesForElements(in:rect) else {return []}
        var x: CGFloat = sectionInset.left
        var y: CGFloat = -1.0
        
        for a in att {
            if a.representedElementCategory != .cell { continue }
            
            if a.frame.origin.y >= y { x = sectionInset.left }
            a.frame.origin.x = x
            x += a.frame.width + minimumInteritemSpacing
            y = a.frame.maxY
        }
        return att
    }
}
