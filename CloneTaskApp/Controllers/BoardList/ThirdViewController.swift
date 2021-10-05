//
//  ThirdViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/15.
//

import UIKit
import RxSwift
import Firebase

class ThirdViewController: UIViewController {
    
    let titleLabel = UILabel()
    let tableView = UITableView()
    let alerter = AlartUtil.sharedAlert
    let sharedBoardViewModel = BoardViewModel.sharedBoardViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchBoardInfo()
    }
    
    func setUpTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "ボード選択"
        view.addSubview(titleLabel)
        
        let constraints = [
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: view.frame.width/4),
            titleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: view.frame.height/10)
        ]
    }
        
    func fetchBoardInfo() {
        if sharedBoardViewModel.boards.count != 0 {
            sharedBoardViewModel.boards = []
        }
        sharedBoardViewModel.getBoardName().subscribe { boardData in
            print("発動", self.sharedBoardViewModel.boards)
        } onError: { Error in
            print("エラーです")
        } onCompleted: {
            self.tableView.reloadData()
        }
    }
    
    func setUpTableView() {
        tableView.frame = CGRect(x: self.view.frame.minY, y: 160, width: self.view.frame.maxY, height: self.view.frame.maxY)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    @objc func tapAddButtonItem(_ : UIButton) {
        let vc = AddBoardViewCotroller()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedBoardViewModel.boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = sharedBoardViewModel.boards[indexPath.row].boardName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle:  Bundle.main)
        let nextView = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
        nextView.setNavItem(titleText: sharedBoardViewModel.boards[indexPath.row].boardName)
        alerter.showAlertWithData(vc: self, alerttitle: "画面遷移を行う", message: "ボタンが押され画面遷移が行われます", okTitle: "OK", cancelTitle: "NO", okHandler: {_ in
            self.sharedBoardViewModel.getBoardData(boardId: self.sharedBoardViewModel.boards[indexPath.row].boardID)
            nextView.getList(documentId: self.sharedBoardViewModel.boards[indexPath.row].boardID)
            self.navigationController?.pushViewController(nextView, animated: true)
        }, cancelHandler: {_ in
            return
        }, compliteAction: {
            return
        })
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ThirdViewHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        header.moveToDelegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}

extension ThirdViewController: moveToDelegate{
    func moveTo() {
        let nextView = AddBoardViewCotroller()
        navigationController?.pushViewController(nextView, animated: true)
    }
}

protocol  moveToDelegate {
    func moveTo()
}
