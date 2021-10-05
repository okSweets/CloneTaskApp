//
//  catCollectionViewCell.swift
//  NekoApp
//
//  Created by Shunzhe Ma on 5/28/20.
//  Copyright © 2020 Shunzhe Ma. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class catCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    //Provided by the caller
    var toys: [String] = []
    var catName: String = ""
    
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
        return toys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = toys[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return catName
    }
    
    
}

/*
 Drag delegate
 */
extension catCollectionViewCell: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        //Remember the original owner of the toy so that we can remove the toy from the original cat object
        session.localContext = catName
        //Provide the drag information
        ///Prepare the toy name
        let toyName = toys[indexPath.row]
        guard let toyNameData = toyName.data(using: .utf8) else { return [] }
        ///Prepare the item
        let provider = NSItemProvider()
        provider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(toyNameData, nil)
            return nil
        }
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
    
}

/*
 Drop delegate
 */
extension catCollectionViewCell: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        //Check if the item type is correct
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            //Get the content of the string
            coordinator.session.loadObjects(ofClass: NSString.self) { (fetchedItems) in
                guard let toyName = fetchedItems.first as? String else { return }
                //Tell the delegate to transfer the toy from the original cat to the new cat
                if let originalCatName = coordinator.session.localDragSession?.localContext as? String {
                    self.delegate?.moveToy(toyName: toyName, fromCat: originalCatName, toCat: self.catName)
                }
            }
        }
    }
    
}
