//
//  CardConfirmViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/19.
//

import UIKit

class CardConfirmViewController: UIViewController {
    
    let headerView = UIView()
    let tableView = UITableView()
    var cardInfo: task?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeaderView()
        setUpTableView()
        // Do any additional setup after loading the view.
    }
    
    func setUpTableView() {
        tableView.frame = CGRect(x: 0, y: headerView.frame.height, width: view.frame.maxX, height: view.frame.maxY)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func setUpHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.maxX, height: view.frame.height/20)
        headerView.backgroundColor = .brown
        view.addSubview(headerView)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "カードの詳細"
        label.backgroundColor = .red
        label.textAlignment = .center
        headerView.addSubview(label)
        
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("back", for: .normal)
        backButton.backgroundColor = .blue
        backButton.addTarget(self, action: #selector(tapBackButton), for: UIControl.Event.touchUpInside)
        headerView.addSubview(backButton)
        
        let constraints = [
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            label.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.8),
            label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            label.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.3),
            
            backButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: headerView.frame.maxX/30),
            backButton.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.8),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            backButton.rightAnchor.constraint(equalTo: label.leftAnchor, constant:  -headerView.frame.maxX/10)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
    @objc func tapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension CardConfirmViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = cardInfo?.taskName
        case 1:
            cell.textLabel?.text = cardInfo?.taskDescrption
        case 2:
            cell.textLabel?.text = cardInfo?.startDay
        default:
            cell.textLabel?.text = cardInfo?.deadlineDay
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "カード名"
        case 1:
            return "説明"
        case 2:
            return "開始日"
        default:
            return "期日"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
}
