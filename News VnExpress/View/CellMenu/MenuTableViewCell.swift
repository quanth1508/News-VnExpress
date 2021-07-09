//
//  MenuTableViewCell.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var content: UILabel!
    
    var contentCell: String? {
        didSet {
            content.text = contentCell
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        content.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        content.textColor = UIColor(named: Contants.Color.titleColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
