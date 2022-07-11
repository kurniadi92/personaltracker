//
//  AddDataViewController.swift
//  personaltracker
//
//  Created by kur niadi  on 11/07/22.
//

import UIKit

class AddDataViewController: UIViewController {
    
    @IBOutlet var categoryCollectionView: UICollectionView!
    private let imagePickerHelper = ImagePickerHelper()
    @IBOutlet var imageView: UIImageView!
    
    var okeh = ["namaster","kara", "kokomi", "lokersome", "campuni", "kakao"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        categoryCollectionView.delegate =  self
        categoryCollectionView.dataSource =  self
        categoryCollectionView.collectionViewLayout = LeftAlignedLayout()
        categoryCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func imageTap(_ sender: Any) {
        imagePickerHelper.getImage(root: self) { [weak self] validImage in
            let url = validImage.saveToDocuments(filename: Date().timeIntervalSince1970.description)
            self?.imageView.image = try! UIImage(data: Data(contentsOf: url!))
        }
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

extension AddDataViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: okeh[indexPath.row].count * 5 + 24, height: 42)
    }
}

extension AddDataViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return okeh.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return  UICollectionViewCell() }
        
        cell.setText(text: okeh[indexPath.row])
        
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
