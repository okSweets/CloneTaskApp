//
//  AddBoardViewCotroller.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/15.
//

import UIKit

class AddBoardViewCotroller: UIViewController {
    
    let tableView = UITableView()
    
    let shareAlert = AlartUtil.sharedAlert
    let shareModel = BoardViewModel.sharedBoardViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpNavigationItem()
        setUpTableView()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpNavigationItem() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.title = "ボードの作成"
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    func setUpTableView() {
        tableView.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)! * 1.5, width: view.frame.maxX, height: view.frame.height - (navigationController?.navigationBar.frame.maxY)! * 1.5 )
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FirstAddBoardTableViewCell", bundle: nil), forCellReuseIdentifier: "firstAddBoard")
        view.addSubview(tableView)
    }
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))as! FirstAddBoardTableViewCell
        if cell.textField.text == nil || cell.textField.text == "" {
            shareAlert.showSingleAlert(vc: self, alertTitle: "ボード名を入力してください", message: "必ずボード名を入力してください", okTitle: "OK", okHandler: {_ in
                return
            })
        }
        else {
            shareModel.addboard(boarName: cell.textField.text!).subscribe(onNext: { value in
                self.shareAlert.showSingleAlert(vc: self, alertTitle: value, message: "ボードの追加が完了しました", okTitle: "OK") {_  in
                    self.navigationController?.popViewController(animated: true)
                }
            }) { Error in
                print(Error)
            }
        }
    }

}

extension AddBoardViewCotroller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstAddBoard")as! FirstAddBoardTableViewCell
        cell.backgroundColor = .blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ボード名"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/6
    }

}
