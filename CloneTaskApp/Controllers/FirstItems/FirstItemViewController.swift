//
//  FirstItemViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/20.
//

import UIKit

class FirstItemViewController: UIViewController {
    
    let collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}
