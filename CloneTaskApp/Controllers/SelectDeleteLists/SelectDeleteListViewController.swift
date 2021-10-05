//
//  SelectDeleteListViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/29.
//

import UIKit

class SelectDeleteListViewController: UIViewController {
    
    let tableView = UITableView()
    let PickerTextField = UITextField()
    let saveButton = UIButton()
    let pickerView: UIPickerView = UIPickerView()
    var pickerData: [listData] = []
    
    let shareModel = BoardViewModel.sharedBoardViewModel
    let shareAlert = AlartUtil.sharedAlert

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpNav()
        setUpPickerView()
        // Do any additional setup after loading the view.
    }
    
    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ]
        
        constraints.forEach { layoutConstraint in
            layoutConstraint.isActive = true
        }
        
    }
    
    func setUpNav() {
        navigationItem.title = "削除するリストを選択してください"
    }
    
    func setUpPickerView() {
        pickerData = shareModel.listItems
        // ピッカー設定
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
                
                // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
                
                // インプットビュー設定
        PickerTextField.inputView = pickerView
        PickerTextField.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        PickerTextField.endEditing(true)
        PickerTextField.text = "\(pickerData[pickerView.selectedRow(inComponent: 0)].listName)"
    }
    
    func setUpTextFielf(contetTextView: UIView) {
        
        PickerTextField.translatesAutoresizingMaskIntoConstraints = false
        PickerTextField.layer.cornerRadius = 10.0
        PickerTextField.layer.borderWidth = 1.0
        PickerTextField.layer.borderColor = UIColor.black.cgColor
        
        PickerTextField.placeholder = "リストの削除"
        contetTextView.addSubview(PickerTextField)
        
        let constraints = [
            PickerTextField.heightAnchor.constraint(equalTo: contetTextView.heightAnchor, multiplier: 0.8),
            PickerTextField.centerYAnchor.constraint(equalTo: contetTextView.centerYAnchor),
            PickerTextField.rightAnchor.constraint(equalTo: contetTextView.centerXAnchor),
            PickerTextField.widthAnchor.constraint(equalTo: contetTextView.widthAnchor, multiplier: 0.45)
        ]
        
        constraints.forEach { layoutConstraint in
            layoutConstraint.isActive = true
        }
    }
    
    func setUpSaveButton(contetTextView: UIView) {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("削除", for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.addTarget(self, action: #selector(tapSaveButton), for: UIControl.Event.touchUpInside)
        
        contetTextView.addSubview(saveButton)
        
        let constraints = [
            saveButton.heightAnchor.constraint(equalTo: contetTextView.heightAnchor, multiplier: 0.8),
            saveButton.centerYAnchor.constraint(equalTo: contetTextView.centerYAnchor),
            saveButton.leftAnchor.constraint(equalTo: contetTextView.centerXAnchor, constant: view.frame.width/8),
            saveButton.rightAnchor.constraint(equalTo: contetTextView.leftAnchor, constant: view.frame.width - view.frame.width/10)
        ]
        
        constraints.forEach { layoutConstraint in
            layoutConstraint.isActive = true
        }
    }
    
    @objc func tapSaveButton() {
        print("keita",PickerTextField.text)
        if PickerTextField.text == "" {
            print("エラーです")
            shareAlert.showSingleAlert(vc: self, alertTitle: "削除するリストを指定してください", message: "削除するリストをしなければ行えません", okTitle: "OK", okHandler: nil)
            return
        }
        var listItem: listData?
        
        for list in shareModel.listItems {
            if list.listName == PickerTextField.text {
                listItem = list
            }
        }
        shareModel.deleteList(listId: listItem!.listID).subscribe { value in
            self.shareAlert.showSingleAlert(vc: self, alertTitle: "リストの削除を行いました", message: "指定したリストの削除を行いました", okTitle: "OK") {_  in
                let storyBoard = UIStoryboard(name: "Main", bundle:  Bundle.main)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
                nextVC.getList(documentId: self.shareModel.currentBoard!.boardID)
                nextVC.setNavItem(titleText: self.shareModel.currentBoard!.boardName)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        } onError: { Error in
            print(Error)
        }
    }

}
extension SelectDeleteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        setUpTextFielf(contetTextView: cell.contentView)
        setUpSaveButton(contetTextView: cell.contentView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewCell().frame.height * 1.75
    }
}

extension SelectDeleteListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].listName
    }
}
