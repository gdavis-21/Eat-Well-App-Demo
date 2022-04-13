//
//  JournalTableViewCell.swift
//  EatWell
//
//  Created by Grant Davis on 4/11/22.
//

import UIKit

class JournalTableViewCell: UITableViewCell {

    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var textField: UITextField!
    
    var date: Date? = nil
    var calories: String? = nil
    var notes: String? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        datePicker.date = date ?? Date.now
        textField.text = calories ?? "0"
        textView.text = notes ?? ""

    }
    
    func modifyValues(calories: String, notes: String) {
        textField.text = calories
        textView.text = notes
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
