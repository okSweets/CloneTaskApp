//
//  AddCardsViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/27.
//

import UIKit

class AddCardsViewController: UIViewController {
    
    var tableView = UITableView()
    var PickerTextField = UITextField()
    var pickerView: UIPickerView = UIPickerView()
    let cardNameTextField = UITextField()
    let startDatePicker = UIDatePicker()
    let startDatePickerTextFeild = UITextField()
    let deadlineDatePicker = UIDatePicker()
    let deadlineDatePickerTextFeild = UITextField()
    let saveButton = UIButton()
    
    let startDayDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(startDoneDate))
    let deadlineDayDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(deadlineDoneDate))
    var discriptionString: String?
    
    let shareAlart = AlartUtil.sharedAlert
    let shareModel = BoardViewModel.sharedBoardViewModel
    var pickerData: [listData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = shareModel.listItems
        setUpPickerView()
        setUpTableView()
        setUpButton()
        setUpNavigationBar()
        view.backgroundColor = .white
        setUpDatePiicker(datePicker: startDatePicker, textFeild: startDatePickerTextFeild, doneItem: startDayDoneItem)
        setUpDatePiicker(datePicker: deadlineDatePicker, textFeild: deadlineDatePickerTextFeild, doneItem: deadlineDayDoneItem)
    }
    
    func setUpTextField(contetView: UIView, textField: UITextField) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        contetView.addSubview(textField)
        
        let constraints = [
            textField.leftAnchor.constraint(equalTo: contetView.leftAnchor, constant:  view.frame.maxX * 5/8),
            textField.rightAnchor.constraint(equalTo: contetView.leftAnchor, constant: view.frame.maxX - view.frame.maxX/20),
            textField.centerYAnchor.constraint(equalTo: contetView.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: contetView.heightAnchor, multiplier: 0.7)
        ]
        
        constraints.forEach{ constraint in
            constraint.isActive = true
        }
    }
    
    func setUpPickerView() {
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
    
    func setUpDatePiicker(datePicker: UIDatePicker, textFeild: UITextField, doneItem: UIBarButtonItem) {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        textFeild.inputView = datePicker
                
                // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = doneItem
        toolbar.setItems([spacelItem, doneItem], animated: true)
                
                // インプットビュー設定
        textFeild.inputView = datePicker
        textFeild.inputAccessoryView = toolbar
    }
    
    @objc func startDoneDate() {
        startDatePickerTextFeild.endEditing(true)
                
                // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startDatePickerTextFeild.text = "\(formatter.string(from: startDatePicker.date))"
    }
    
    @objc func deadlineDoneDate() {
        deadlineDatePickerTextFeild.endEditing(true)
                
                // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        deadlineDatePickerTextFeild.text = "\(formatter.string(from: deadlineDatePicker.date))"
    }
    
    
    
    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let constraints = [
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6 )
        ]
        
        constraints.forEach{
            $0.isActive = true
        }
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "カードの追加"
    }
    
    func setUpButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("作成する", for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.addTarget(self, action: #selector(tapSaveButton), for: UIControl.Event.touchUpInside)
        view.addSubview(saveButton)
        
        let constraints = [
            saveButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 40),
            saveButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25)
        ]
        
        constraints.forEach { constraint in
            constraint.isActive = true
        }
    }
    
    @objc func tapSaveButton() {
        checkNewContents()
        let listID = getListId()
        shareModel.addCard(listID: listID, cardName: cardNameTextField.text!, startDay: startDatePickerTextFeild.text!, deadlineDay: deadlineDatePickerTextFeild.text!, description: discriptionString!).subscribe { value in
            self.shareAlart.showSingleAlert(vc: self, alertTitle: value, message: "変更を保存しました", okTitle: "OK") {_  in
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
    
    func getListId()-> String {
        var listID = ""
        for listDate in pickerData {
            if listDate.listName == PickerTextField.text {
                listID = listDate.listID
            }
        }
        return listID
    }
    func checkNewContents() {
        if PickerTextField.text == "" || PickerTextField.text == nil {
            shareAlart.showSingleAlert(vc: self, alertTitle: "リストの指定を行ってください", message: "リストの指定なしにはカードを作れません", okTitle: "OK") {_ in
                return
            }
        }
        if cardNameTextField.text == "" || cardNameTextField.text == nil {
            shareAlart.showSingleAlert(vc: self, alertTitle: "カード名の入力を行ってください", message: "カード名の指定なしにはカードを作れません", okTitle: "OK") {_ in
                return
            }
        }
        if startDatePickerTextFeild.text == "" || startDatePickerTextFeild.text == nil {
            startDatePickerTextFeild.text = ""
        }
        if deadlineDatePickerTextFeild.text == "" || deadlineDatePickerTextFeild.text == nil {
            deadlineDatePickerTextFeild.text = ""
        }
        if discriptionString == nil {
            discriptionString = ""
        }
    }

}

extension AddCardsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .lightGray
        if indexPath.row == 0 {
            setUpTextField(contetView: cell.contentView, textField: PickerTextField)
            cell.textLabel?.text = "リストの選択"
        }
        else if indexPath.row == 1 {
            setUpTextField(contetView: cell.contentView, textField: cardNameTextField)
            cell.textLabel?.text = "カード名を入力"
        }
        else if indexPath.row == 2 {
            setUpTextField(contetView: cell.contentView, textField: startDatePickerTextFeild)
            cell.textLabel?.text = "開始日の入力"
        }
        else if indexPath.row == 3 {
            setUpTextField(contetView: cell.contentView, textField: deadlineDatePickerTextFeild)
            cell.textLabel?.text = "期日の入力"
        }
        else {
            cell.textLabel?.text = "説明の追加"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "カードの編集"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewCell().contentView.frame.height * 1.5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewCell().contentView.frame.height * 1.25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let vc = AddDescriptionViewController()
            present(vc, animated: true, completion: nil)
        }
    }
}
extension AddCardsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
