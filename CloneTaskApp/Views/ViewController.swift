//
//  ViewController.swift
//  NekoApp
//
//  Created by Shunzhe Ma on 5/28/20.
//  Copyright © 2020 Shunzhe Ma. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var cats : [String] = []
    var catToys: [String: [String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cats = ["ネコノヒー", "ムギ", "レオ"]
        catToys["ネコノヒー"] = ["ペット小屋", "ぐるぐるタワー"]
        catToys["ムギ"] = []
        catToys["レオ"] = ["ぬいぐるみ"]
        collectionView.reloadData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let catName = cats[indexPath.row]
        guard let catToys = catToys[catName] else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catCollectionViewCell", for: indexPath) as! catCollectionViewCell
        cell.toys = catToys
        cell.catName = catName
        cell.delegate = self
        cell.tableView.reloadData()
        return cell
    }


}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: collectionView.bounds.height * 0.22)
    }
    
}

/*
 This function will be called everytime a toy is transferred
 */
extension ViewController: dragAndDropActionDelegate {
    
    func moveToy(toyName: String, fromCat: String, toCat: String) {
        //Take the toy away from the fromCat
        var fromCatToys = catToys[fromCat] ?? []
        fromCatToys.removeAll { (toyNameInArray) -> Bool in
            return toyNameInArray == toyName
        }
        catToys[fromCat] = fromCatToys
        //Give the toy to new cat
        var toCatToys = catToys[toCat] ?? []
        toCatToys.append(toyName)
        catToys[toCat] = toCatToys
        //Update the fromCat tableview
        collectionView.reloadData()
    }
    
}

/*
 Optional
 - Just used to show the story
 */
extension ViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Show the story
        showStory()
    }
    
    func showStory(){
        let alert = UIAlertController(title: "The Story", message: "I have three lovely cats. And I use this app to track which toy they currently are currently playing with.", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    
}

protocol dragAndDropActionDelegate: AnyObject {
    func moveToy(toyName: String, fromCat: String, toCat: String)
}
