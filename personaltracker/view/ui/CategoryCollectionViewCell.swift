//
//  CategoryCollectionViewCell.swift
//  personaltracker
//
//  Created by kur niadi  on 11/07/22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet var bgView: UIView!
    @IBOutlet var categoryTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 12
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.borderWidth =  0.3
    }
    
    func setText(text: String)  {
        categoryTitleLabel.text = text
    }
 
}
