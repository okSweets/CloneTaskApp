//
//  FirstAddBoardTableViewCell.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/17.
//

import UIKit

class FirstAddBoardTableViewCell: UITableViewCell {
    
    var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpTextField() {
        textField = UITextField()
        textField.placeholder = "  必ず入力してください"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 0.3
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 7
        
        let constraints: [NSLayoutConstraint] = [
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30)
        ]
        
        addSubview(textField)
        constraints.forEach({
            $0.isActive = true
        })
        
    }
    
}
