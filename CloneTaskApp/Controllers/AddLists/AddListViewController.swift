//
//  AddListViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/28.
//

import UIKit

class AddListViewController: UIViewController {
    
    let tableView = UITableView()
    let saveButton = UIButton()
    let textField = UITextField()
    
    let shareModel = BoardViewModel.sharedBoardViewModel
    let shareAlert = AlartUtil.sharedAlert

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1.0)
        setUpTableView()
        setUpNavItem()
        setUpSaveButton()
    }
    
    func setUpNavItem() {
        navigationItem.title = "リストの追加"
        let backItem  = UIBarButtonItem(title: "✖️", style: .plain, target: self, action: #selector(tapBackButton))
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/4),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        constraints.forEach { layoutConstraint in
            layoutConstraint.isActive = true
        }
    }
    
    func setUpSaveButton() {
        saveButton.setTitle("追加する", for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(tapSaveButton), for: UIControl.Event.touchUpInside)
        
        view.addSubview(saveButton)
        
        let constraints = [
            saveButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            saveButton.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 80)
        ]
        
        constraints.forEach { layoutConstraint in
            layoutConstraint.isActive = true
        }
        
    }
    
    @objc func tapSaveButton() {
        print("よい", shareModel.currentBoard)
        if textField.text == "" || textField.text == nil {
            shareAlert.showSingleAlert(vc: self, alertTitle: "リスト名を追加してください", message: "リスト名がないため、新たなリストを作成できません", okTitle: "OK") {_  in
                return
            }
        }
        else {
            shareModel.addList(boardID: shareModel.currentBoard!.boardID, listName: textField.text!).subscribe { value in
                self.shareAlert.showSingleAlert(vc: self, alertTitle: "リストの追加をしました", message: "新たなリストの追加を行いました", okTitle: "OK") {_  in
                    let storyBoard = UIStoryboard(name: "Main", bundle:  Bundle.main)
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
                    nextVC.getList(documentId: self.shareModel.currentBoard!.boardID)
                    nextVC.setNavItem(titleText: self.shareModel.currentBoard!.boardName)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
        }
    }

}
extension AddListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "リスト名を追加"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor.black.cgColor
        
        cell.contentView.addSubview(textField)
        
        let constraints = [
            textField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor, multiplier: 0.8),
            textField.leftAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            textField.rightAnchor.constraint(equalTo: cell.centerXAnchor, constant: view.frame.width/2 - 30)
        ]
        
        constraints.forEach { layoutConstraint in
            layoutConstraint.isActive = true
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewCell().contentView.frame.height * 1.5
    }
}
