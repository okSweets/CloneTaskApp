//
//  SecondViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/19.
//

import UIKit
import FSCalendar

class SecondViewController: UIViewController {
    
    let calendar = FSCalendar()
    let titleLabel = UILabel()
    var getDateDelegate: getDateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCalendar()
        setUpLabel()
        //setUpSubLabel()
    }
    
    func setUpLabel() {
        titleLabel.text = "期日検索"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: calendar.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ]
        
        constraints.forEach { layoutConstraint in
            layoutConstraint.isActive = true
        }
    }
    
    func setUpCalendar() {
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        view.addSubview(calendar)
        
        let constraints = [
            calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            calendar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            calendar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/3)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
}

extension SecondViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let nextVC = DateDetailViewController()
        self.getDateDelegate = nextVC
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        getDateDelegate?.getDate(date: "\(year)-\(month)-\(day)")
        present(nextVC, animated: true, completion: nil)
    }
}

protocol getDateDelegate {
    func getDate(date: String)
}
