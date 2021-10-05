//
//  MoveToCardViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/17.
//

import UIKit

class MoveToCardViewController: UIViewController {
    
    let shareAlert = AlartUtil.sharedAlert
    let shareModel = BoardViewModel.sharedBoardViewModel
    
    var boardList: [listData] = []
    let tableView = UITableView()
    let saveButton = UIButton()
    var buttonTitle  = "移動先のボードを設定" {
        didSet {
            saveButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpButon()
        saveButton.addTarget(self, action: #selector(onTapSaveButton(_:)), for: UIControl.Event.touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    func setUpTableView() {
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.maxX, height: view.frame.maxY/2)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func setUpButon() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle(buttonTitle, for: .normal)
        saveButton.backgroundColor = .red
        saveButton.layer.cornerRadius = 10
        view.addSubview(saveButton)
        
        let constraints: [NSLayoutConstraint] = [
            saveButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            saveButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
    func getAllListInfo() {
        shareModel.getAllListInfo(boardID: shareModel.currentBoard!.boardID).subscribe { value in
            value.forEach { listData in
                self.boardList.append(listData)
            }
            self.tableView.reloadData()
        } onError: { Error in
            print("エラーが発生しました")
        }
    }
    
    @objc func onTapSaveButton(_ sender: UIButton) {
        if buttonTitle == "移動先のボードを設定" {
            shareAlert.showSingleAlert(vc: self, alertTitle: "変更がありませんでした", message: "変更せずに戻ります", okTitle: "OK", okHandler: {_ in
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            shareModel.selectMoveCard(listTitle: buttonTitle).subscribe { value in
                self.shareAlert.showSingleAlert(vc: self, alertTitle: self.buttonTitle, message: "\(self.buttonTitle)し、保存しました", okTitle: "OK", okHandler: {_ in
                    self.dismiss(animated: true, completion: nil)
                })
            } onError: { error in
                print(error)
            }
        }
    }
}

extension MoveToCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = boardList[indexPath.row].listName
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MoveToCardHeaderView(frame: CGRect(x: tableView.frame.minX, y: tableView.frame.minY, width: self.view.frame.maxX, height: tableView.frame.height/3))
        headerView.dismissDelegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        buttonTitle = "\(boardList[indexPath.row].listName)に変更"
    }
}

extension MoveToCardViewController: dismissFromEditMoveBoaed {
    func dismissFromEditMove() {
        shareAlert.showAlert(vc: self, alerttitle: "変更を中止しますか？？", message: "中止した場合は破棄されます", okTitle: "OK", cancelTitle: "続ける", okHandler: { _ in self.dismiss(animated: true, completion: nil)}, cancelHandler: { _ in return}, compliteAction: {  return})
    }
}

protocol dismissFromEditMoveBoaed {
    func dismissFromEditMove()
}
