//
//  ViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/14.
//

import UIKit
import RxSwift

class ViewController: UICollectionViewController {
    
    var lists : [String] = []
    let alerter = AlartUtil.sharedAlert
    let shareBoardViewModel = BoardViewModel.sharedBoardViewModel
    
    let disposeBag = DisposeBag()
    var tasks: [String: [String]] = [:]{
        didSet {
            guard let taskFirst = Array(tasks.keys).first else {
                return
            }
            if tasks[taskFirst]?.count == 0 {
                return
            }
            count += 1
            print("動いた", Date(), count)
            shareBoardViewModel.movingTask(listName: Array(tasks.keys).first!, cardName: (tasks[taskFirst]?.last)!)
        }
    }
    var count = 0


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func moveToList(listName: String,taskName: String) {
        shareBoardViewModel.movingTask(listName: listName, cardName: taskName)
    }
    
    func getList(documentId: String) {
        shareBoardViewModel.getBoardDetail(boardId: documentId).subscribe { value in
            var taskList: [String] = []
            for listData in value {
                self.lists.append(listData.listName)
                for task in listData.tasks {
                    taskList.append(task.taskName)
                }
                self.tasks[listData.listName] = taskList
                taskList = []
            }
            self.collectionView.reloadData()
        } onError: { Error in
            print("エラーです")
        }
    }
    
    func setNavItem(titleText: String) {
        navigationItem.title =  titleText
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onTapBackButton))
        navigationItem.leftBarButtonItem = backButton
        let editButton = UIBarButtonItem(title: "編集", style: .plain, target: self, action: #selector(onTapEditButton(_:)))
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func onTapBackButton() {
        let vc = ThirdViewController()
        vc.navigationItem.hidesBackButton = true
        vc.navigationItem.title = "アプリ名"
        shareBoardViewModel.boards = []
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onTapEditButton(_ sender: Any) {
        let vc = PanModalTableViewController()
        vc.segueDelegate = self
        presentPanModal(vc)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listName = lists[indexPath.row]
        guard let tasks = tasks[listName] else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.tasks = tasks
        cell.listName = listName
        cell.delegate = self
        cell.moveToDelegate = self
        cell.tableView.reloadData()
        return cell
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: collectionView.bounds.height * 0.22)
    }
    
}

extension ViewController: dragAndDropActionDelegate {
    
    func moveTo(taskName: String, fromList: String, toList: String) {
        
        var fromListTask = tasks[fromList] ?? []
        fromListTask.removeAll { (taskNameInArray) -> Bool in
            return taskNameInArray == taskName
        }
        tasks[fromList] = fromListTask
        var toListTask = tasks[toList] ?? []
        toListTask.append(taskName)
        tasks[toList] = toListTask
        
        collectionView.reloadData()
    }
    
}

extension ViewController: segueDelegate {
    func backTo() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func moveTo(nextViewController: UIViewController) {
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

protocol dragAndDropActionDelegate: AnyObject {
    func moveTo(taskName: String, fromList: String, toList: String)
}

protocol segueDelegate {
    func moveTo(nextViewController: UIViewController)
    func backTo()
}





