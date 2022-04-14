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
    
    var date: Date?
    var calories: String?
    var notes: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.text = calories ?? "0"
        textView.text = notes ?? ""
        datePicker.date = date ?? Date.now

    }
    
    func updateValues(calories: String, notes: String, date: Date) {
        // Update calories variable to reflect user input.
        textField.text = calories
        // Update notes variable to reflect user input.
        textView.text = notes
        // Update date variable to reflect user input.
        datePicker.date = date
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
