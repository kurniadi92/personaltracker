//
//  RecordTableViewCell.swift
//  personaltracker
//
//  Created by kur niadi  on 13/07/22.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet var typeView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(item: RecordCellViewParam) {
        let typeRecordColor = item.type == "expense" ? UIColor.red : UIColor.green
        typeView.backgroundColor = typeRecordColor
        
        dateLabel.text = item.formattedDate
        nameLabel.text = item.title
        categoryLabel.text = item.category
        amountLabel.text = item.amount.description
    }
    
}
