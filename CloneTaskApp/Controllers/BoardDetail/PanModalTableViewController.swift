//
//  PanModalTableViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/28.
//

import UIKit
import PanModal

class PanModalTableViewController: UITableViewController {
    
    let shareModel = BoardViewModel.sharedBoardViewModel
    
    var segueDelegate: segueDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row == 0 {
            cell.textLabel?.text = "リストを追加"
        }
        if shareModel.listItems.count == 0 {
            return cell
        }
        else if indexPath.row == 1 {
            cell.textLabel?.text = "カードを追加"
        }
        else {
            cell.textLabel?.text = "リストを削除する"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let nextVC = AddListViewController()
            segueDelegate?.moveTo(nextViewController: nextVC)
        case 1:
            let nextVC = AddCardsViewController()
            segueDelegate?.moveTo(nextViewController: nextVC)
        default:
            let nextVC = SelectDeleteListViewController()
            segueDelegate?.moveTo(nextViewController: nextVC)
        }
        dismiss(animated: true, completion: nil)
    }
}
extension PanModalTableViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var  longFormHeight: PanModalHeight {
        return .contentHeight(200)
        
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }

}
