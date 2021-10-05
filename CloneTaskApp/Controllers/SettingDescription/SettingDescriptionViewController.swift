//
//  SettingDescriptionViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/18.
//

import UIKit

class SettingDescriptionViewController: UIViewController {
    
    var maxWordCount: Int = 55
    let placeholder: String = "テキストを入力"
    let wordCountLabel = UILabel()
    let textView = UITextView()
    
    let shareAlert = AlartUtil.sharedAlert
    let shareModel = BoardViewModel.sharedBoardViewModel
    
    var task: task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpNavigationItem()
        setUpTextView()
        setUpLabel()
        view.backgroundColor = .white
    }
    
    func setUpNavigationItem() {
        navigationItem .title = "説明"
        let rigthButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapRightButton))
        self.navigationItem.rightBarButtonItem = rigthButton
    }
    
    @objc func tapRightButton() {
        shareAlert.showAlert(vc: self, alerttitle: "変更を保存しますか？", message: "変更の反映を行いますか？？", okTitle: "OK", cancelTitle: "いいえ",okHandler: {_ in
            self.changeCardDiscription(description: self.textView.text)
        } , cancelHandler: {_ in return}, compliteAction: nil)
    }
    
    func changeCardDiscription(description: String) {
        shareModel.changeCarddescription(description: description, card: task).subscribe { value in
            self.shareAlert.showSingleAlert(vc: self, alertTitle: value, message: "説明の変更を行いました", okTitle: "OK") {_  in
                
            let nav = self.navigationController
            let nextVC = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! NextViewController
            if description == "" {
                nextVC.checkDescLabel.text = "未追加"
            }
            else {
                nextVC.checkDescLabel.text = "✔️追加済み"
            }
                nextVC.getDetailInfo(cardName: self.shareModel.currentCard!.taskName)
            self.navigationController?.popViewController(animated: true)
            }
        } onError: { Error in
            self.shareAlert.showSingleAlert(vc: self, alertTitle: "変更に失敗しました", message: "保存に失敗したため、変更できませんでした", okTitle: "OK"){_  in
                return
            }

        }
    }
    
    func setUpTextView() {
        textView.frame = CGRect(x: 0, y: view.frame.height/5, width: view.frame.maxX, height: view.frame.maxY - (navigationController?.navigationBar.frame.height)!)
        textView.delegate = self
        textView.text = task.taskDescrption
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
                //下にスワイプでキーボードを下げる
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDownGesture.direction = .down
        self.view.addGestureRecognizer(swipeDownGesture)
        textView.backgroundColor = .lightGray
        view.addSubview(textView)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setUpLabel() {
        wordCountLabel.text = "最大文字数\(maxWordCount - textView.text.count)/\(maxWordCount)"
        wordCountLabel.translatesAutoresizingMaskIntoConstraints = false
        wordCountLabel.backgroundColor = .white
        wordCountLabel.textAlignment = .center
        view.addSubview(wordCountLabel)
        
        let constraints: [NSLayoutConstraint] = [
            wordCountLabel.topAnchor.constraint(equalTo:view.topAnchor, constant: navigationController!.navigationBar.frame.height),
            //wordCountLabel.topAnchor.constraint(equalTo:view.topAnchor, constant: 80),
            wordCountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            wordCountLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            wordCountLabel.bottomAnchor.constraint(equalTo: textView.topAnchor)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
}
extension SettingDescriptionViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let existingLines = textView.text.components(separatedBy: .newlines)
        let newLines = text.components(separatedBy: .newlines)
        let linesAfterChange = existingLines.count + newLines.count - 1
        return linesAfterChange <= 3 && textView.text.count + (text.count - range.length) <= maxWordCount
    }
            
    func textViewDidChange(_ textView: UITextView) {
        self.wordCountLabel.text = "最大文字数\(maxWordCount - textView.text.count)/\(maxWordCount)"
    }
            
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .darkText
        }
    }
     
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .darkGray
            textView.text = placeholder
        }
    }
}
