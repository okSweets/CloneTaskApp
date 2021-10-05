//
//  DateDetailViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/19.
//

import UIKit

struct task {
    var taskId: String
    var listID: String
    var taskName: String
    var taskDescrption: String
    var startDay: String
    var deadlineDay: String
}

class DateDetailViewController: UIViewController {
    
    var taskList: [task] = [] {
        didSet {
            showTasks(tasks: taskList)
        }
    }
    let settingDateTextFeild = UITextField()
    var datePicker: UIDatePicker = UIDatePicker()
    let backButton = UIButton()
    
    let shareModel = BoardViewModel.sharedBoardViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFeild()
        setUpPicker()
        setUpButton()
        self.view.backgroundColor = .brown
        // Do any additional setup after loading the view.
    }
    
    func setUpTextFeild() {
        settingDateTextFeild.translatesAutoresizingMaskIntoConstraints = false
        settingDateTextFeild.textAlignment = .center
        view.addSubview(settingDateTextFeild)
        
        let constraints = [
            settingDateTextFeild.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            settingDateTextFeild.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            settingDateTextFeild.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            settingDateTextFeild.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
    func setUpPicker() {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        settingDateTextFeild.inputView = datePicker
                
                // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
                
                // インプットビュー設定
        settingDateTextFeild.inputView = datePicker
        settingDateTextFeild.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        settingDateTextFeild.endEditing(true)
            
            // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        settingDateTextFeild.text = "\(formatter.string(from: datePicker.date))"
        getTask(date: formatter.string(from: datePicker.date))
    }
    
    func setUpButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("< back", for: .normal)
        backButton.contentHorizontalAlignment = .left
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(tapBackButton(_:)), for: UIControl.Event.touchUpInside)
        
        let constraints = [
            backButton.heightAnchor.constraint(equalTo: settingDateTextFeild.heightAnchor),
            backButton.centerYAnchor.constraint(equalTo: settingDateTextFeild.centerYAnchor),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            backButton.rightAnchor.constraint(equalTo: settingDateTextFeild.leftAnchor, constant: -20)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
    @objc func tapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getTask(date: String) {
        shareModel.getTaskFromDate(date: date).subscribe { value in
            self.taskList = value
        } onError: { Error in
            print(Error)
            return
        }
    }
    
    func showTasks(tasks: [task]) {
        print(taskList.count)
        self.viewDidLoad()
        if tasks.count == 0 {
            let taskLabel = UILabel()
            taskLabel.translatesAutoresizingMaskIntoConstraints = false
            taskLabel.text = "何もタスクがありません"
            taskLabel.textAlignment = .center
            taskLabel.backgroundColor = .gray
            self.view.addSubview(taskLabel)

            let constraints: [NSLayoutConstraint] = [
                taskLabel.topAnchor.constraint(equalTo: settingDateTextFeild.bottomAnchor, constant: 30),
                taskLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
                taskLabel.heightAnchor.constraint(equalTo: settingDateTextFeild.heightAnchor),
                taskLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]

            constraints.forEach({
                $0.isActive = true
            })
        }
        else {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(DateDetailTableViewCell.self, forCellReuseIdentifier: "dateDetail")
            view.addSubview(tableView)
            
            let constraints: [NSLayoutConstraint] = [
                tableView.topAnchor.constraint(equalTo: settingDateTextFeild.bottomAnchor, constant: 30),
                tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
                tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
                tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]
            
            constraints.forEach({
                $0.isActive = true
            })
        }
    }
}

extension DateDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DateDetailTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "dateDetail", task: taskList[indexPath.row], viewWidth: view.frame.width)
        if taskList.count == 0 {
            cell.textLabel?.text = "期日のタスクはありません"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = CardConfirmViewController()
        nextVC.cardInfo = taskList[indexPath.row]
        present(nextVC, animated: true, completion: nil)
    }
}

extension DateDetailViewController: getDateDelegate {
    func getDate(date: String) {
        settingDateTextFeild.text = date
        getTask(date: date)
    }
}
