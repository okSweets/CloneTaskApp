//
//  EditCardNameViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/18.
//

import UIKit

class EditCardNameViewController: UIViewController {

    let shareAlert = AlartUtil.sharedAlert
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavigationItem()
    }
    
    
    func setUpNavigationItem() {
        navigationItem.title = "カード名の変更"
        let rigthButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapRightButton))
        self.navigationItem.rightBarButtonItem = rigthButton
        
    }
    
    @objc func tapRightButton() {
//        shareAlert.showAlert(vc: self, alerttitle: "変更を保存しますか？", message: "変更の反映を行いますか？？", okTitle: "OK", cancelTitle: "いいえ", okHandler: {_ in
//            if self.textField.text == "" {
//                self.shareAlert.showSingleAlert(vc: self, alertTitle: "未入力です", message: "カード名は必須です", okTitle: "はい", okHandler: {_ in return})
//            }
//            else {
//                let prevVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-1]
//                prevVC?.navigationItem.title = self.textField.text
//                self.navigationController?.popViewController(animated: true)
//            }
//        } ,
//            cancelHandler: {_ in return}, compliteAction: nil)
   }
}
