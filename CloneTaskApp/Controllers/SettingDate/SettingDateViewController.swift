//
//  SettingNameViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/18.
//

import UIKit

class SettingDateViewController: UIViewController {
    
    let tableView = UITableView()
    var datePicker: UIDatePicker = UIDatePicker()
    let settingStartDateTextFeild = UITextField()
    let settingEndDateTextFeild = UITextField()
    
    let shareAlert = AlartUtil.sharedAlert
    let shareModel = BoardViewModel.sharedBoardViewModel
    
    var task: task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpTableView()
        setUpNavigationItem()
    }
    
    func setUpTextFeild(textFeild: UITextField, cell: UITableViewCell) {
        textFeild.translatesAutoresizingMaskIntoConstraints = false
        textFeild.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 200/255, alpha: 1)
        textFeild.textAlignment = .center
        cell.contentView.addSubview(textFeild)
        
        let constraints = [
            textFeild.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            textFeild.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor, multiplier: 0.7),
            textFeild.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -30),
            textFeild.leftAnchor.constraint(equalTo: cell.contentView.centerXAnchor, constant: 30)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
    let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    let done2Item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
    
    func setUpPicker(textFeild: UITextField, doneItem: UIBarButtonItem) {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        textFeild.inputView = datePicker
                
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = doneItem
        toolbar.setItems([spacelItem, doneItem], animated: true)
                
        textFeild.inputView = datePicker
        textFeild.inputAccessoryView = toolbar
    }
    
    func setUpNavigationItem() {
        navigationItem.title = "期日の変更"
        let rigthButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapRightButton))
        self.navigationItem.rightBarButtonItem = rigthButton
        
    }
    
    @objc func tapRightButton() {
        shareAlert.showAlert(vc: self, alerttitle: "変更を保存しますか？", message: "変更の反映を行いますか？？", okTitle: "OK", cancelTitle: "いいえ", okHandler: {_ in
            self.changeCardChange(startDay: self.settingStartDateTextFeild.text!, endDay: self.settingEndDateTextFeild.text!)
        } , cancelHandler: {_ in return}, compliteAction: nil)
    }
    
    func changeCardChange(startDay: String, endDay: String) {
        shareModel.changeCardDay(startDay: startDay, endDay: endDay, card: task).subscribe { value in
            self.shareAlert.showSingleAlert(vc: self, alertTitle: value, message: "期日の変更を行いましいた", okTitle: "OK") {_  in
                let nav = self.navigationController
                let nextVC = nav!.viewControllers[(nav?.viewControllers.count)!-2] as! NextViewController
                nextVC.startDaylabel.text = "開始日:\(self.settingStartDateTextFeild.text!)"
                nextVC.endDaylabel.text = "期日:\(self.settingEndDateTextFeild.text!)"
                nextVC.getDetailInfo(cardName: self.shareModel.currentCard!.taskName)
            }
        } onError: { Error in
            self.shareAlert.showSingleAlert(vc: self, alertTitle: "変更に失敗しました", message: "保存に失敗したため、変更できませんでした", okTitle: "OK") {_  in
                return
            }
        }
    }
    
    @objc func done2(textFeild: UITextField) {
        settingStartDateTextFeild.endEditing(true)
            
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        settingEndDateTextFeild.text = "\(formatter.string(from: datePicker.date))"
    }
    
    @objc func done(textFeild: UITextField) {
        settingStartDateTextFeild.endEditing(true)
            
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        settingStartDateTextFeild.text = "\(formatter.string(from: datePicker.date))"
    }
    
    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }

}

extension SettingDateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0 {
            setUpTextFeild(textFeild: settingStartDateTextFeild, cell: cell)
            setUpPicker(textFeild: settingStartDateTextFeild, doneItem: doneItem)
            settingStartDateTextFeild.text = task.startDay
            cell.textLabel?.text = "開始日を設定する"
        }
        else {
            setUpTextFeild(textFeild: settingEndDateTextFeild, cell: cell)
            setUpPicker(textFeild: settingEndDateTextFeild, doneItem: done2Item)
            settingEndDateTextFeild.text = task.deadlineDay
            cell.textLabel?.text = "期日を追加する"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewCell().contentView.frame.height * 1.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    
}
