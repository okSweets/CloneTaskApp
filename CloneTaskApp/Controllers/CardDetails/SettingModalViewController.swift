//
//  SettingModalViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/17.
//

import UIKit
import PanModal

class SettingModalViewController: UIViewController {
    
    let shareModel = BoardViewModel.sharedBoardViewModel
    let shareAlert = AlartUtil.sharedAlert
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        setUpTableView()
        // Do any additional setup after loading the view.
    }
    
    func setUpTableView() {
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.maxX, height: view.frame.maxY)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func deleteCard(cardId: String) {
        shareModel.deleteItem(cardId: cardId).subscribe { value in
            self.shareAlert.showSingleAlert(vc: self, alertTitle: value, message: "削除に成功しました", okTitle: "OK", okHandler: {_ in
                let storyBoard = UIStoryboard(name: "Main", bundle:  Bundle.main)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "viewController") as! ViewController
                nextVC.getList(documentId: self.shareModel.currentBoard!.boardID)
                nextVC.setNavItem(titleText: self.shareModel.currentBoard!.boardName)
                nextVC.navigationItem.hidesBackButton = true
                self.navigationController!.pushViewController(nextVC, animated: true)

//                let vc = NextViewController()
//                vc.dismissflg = true
//                self.dismiss(animated: true, completion: nil)
            })
        } onError: { Error in
            self.shareAlert.showSingleAlert(vc: self, alertTitle: "削除できませんでした", message: "削除に失敗したため、元の状態を保存されます", okTitle: "OK", okHandler: {_ in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }

}

extension SettingModalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SettingModalHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.maxX, height: tableView.frame.height/3))
        headerView.dismissDelegate = self
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "カードを移動する"
        default:
            cell.textLabel?.text = "このカードを削除する"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let nextVC = UIStoryboard(name: "MoveToCardViewController", bundle: nil).instantiateViewController(identifier: "moveToCard") as! MoveToCardViewController
            nextVC.getAllListInfo()
            present(nextVC, animated: true)
        default:
            shareAlert.showAlert(vc: self, alerttitle: "カードを削除しますか?", message: "削除後にカードを戻すことはできません", okTitle: "OK", cancelTitle: "やめる", okHandler: {_ in
                self.deleteCard(cardId: self.shareModel.currentCard!.taskId)
            }, cancelHandler: nil, compliteAction: nil)
        }
    }
    
    
    
}

extension SettingModalViewController: dismissDelegate{
    func dismissFunction() {
        dismiss(animated: true, completion: nil)
    }
}

protocol dismissDelegate {
    func dismissFunction()
}
