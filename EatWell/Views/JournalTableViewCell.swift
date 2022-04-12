//
//  JournalTableViewCell.swift
//  EatWell
//
//  Created by Grant Davis on 4/11/22.
//

import UIKit

class JournalTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top:25, left: 0, bottom: 0, right: 0))
    }

}
