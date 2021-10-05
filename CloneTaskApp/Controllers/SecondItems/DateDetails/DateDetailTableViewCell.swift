//
//  DateDetailTableViewCell.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/19.
//

import UIKit

class DateDetailTableViewCell: UITableViewCell {
    
    let namelabel = UILabel()
    let deadlineDayLabel = UILabel()
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, task: task, viewWidth: CGFloat) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLabel(task: task, viewWidth: viewWidth)
    }
    
    func setUpLabel(task: task, viewWidth: CGFloat) {
        namelabel.text = "\(task.taskName)"
        namelabel.font = UIFont.systemFont(ofSize: 30)
        //namelabel.backgroundColor = .blue
        deadlineDayLabel.text = "期日: \(task.deadlineDay)"
        deadlineDayLabel.font = UIFont.systemFont(ofSize: 10)
        //deadlineDayLabel.backgroundColor = .green
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineDayLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(namelabel)
        addSubview(deadlineDayLabel)
        
        let constraints = [
            namelabel.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/10),
            namelabel.rightAnchor.constraint(equalTo: leftAnchor, constant: viewWidth * 4/5),
            namelabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            namelabel.leftAnchor.constraint(equalTo: leftAnchor, constant: viewWidth/10),
            
            deadlineDayLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: frame.height/10),
            deadlineDayLabel.rightAnchor.constraint(equalTo: leftAnchor, constant: viewWidth * 4/5),
            deadlineDayLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                                                     //, constant: -frame.height/50),
            deadlineDayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: viewWidth/10)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
