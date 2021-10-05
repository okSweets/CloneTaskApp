//
//  catCollectionViewCell.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/14.
//

import Foundation
import UIKit
import MobileCoreServices

class CollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    //Provided by the caller
    
    var tasks: [String] = []
    var listName: String = ""
    var moveToDelegate: segueDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: dragAndDropActionDelegate?
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        //Set up drag
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        //Set up drop
        tableView.dropDelegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NextViewController()
        vc.navigationItem.title = tasks[indexPath.row]
        vc.getDetailInfo(cardName: tasks[indexPath.row])
        moveToDelegate?.moveTo(nextViewController: vc)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listName
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //getInfodelegate?.getInfo()
    }
}

/*
 Drag delegate
 */
extension CollectionViewCell: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = listName
        //Provide the drag information
        let taskName = tasks[indexPath.row]
        guard let taskeNameData = taskName.data(using: .utf8) else { return [] }
        ///Prepare the item
        let provider = NSItemProvider()
        provider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(taskeNameData, nil)
            return nil
        }
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
    
}

/*
 Drop delegate
 */
extension CollectionViewCell: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        //Check if the item type is correct
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            //Get the content of the string
            coordinator.session.loadObjects(ofClass: NSString.self) { (fetchedItems) in
                guard let taskName = fetchedItems.first as? String else { return }
                if let originalListName = coordinator.session.localDragSession?.localContext as? String {
                    self.delegate?.moveTo(taskName: taskName, fromList: originalListName, toList: self.listName)
                }
            }
        }
    }
    
}
