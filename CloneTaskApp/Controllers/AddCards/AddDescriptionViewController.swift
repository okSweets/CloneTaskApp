//
//  AddDescriptionViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/27.
//

import UIKit

class AddDescriptionViewController: UIViewController {
    
    var maxWordCount: Int = 55
    let placeholder: String = "テキストを入力"
    let wordCountLabel = UILabel()
    let textView = UITextView()
    let header = UIView()
    let saveButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpLabel()
        setUpTextView()
        setUpSaveButton()
        view.backgroundColor = .white
    }
    
    func setUpTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
                //下にスワイプでキーボードを下げる
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDownGesture.direction = .down
        self.view.addGestureRecognizer(swipeDownGesture)
        textView.backgroundColor = .lightGray
        view.addSubview(textView)
        
        let constraints = [
            textView.topAnchor.constraint(equalTo: wordCountLabel.bottomAnchor, constant: 30),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor),
            textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3)
        ]
        
        constraints.forEach { constraint in
            constraint.isActive = true
        }
    }
    
    func setUpSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("保存する", for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.addTarget(self, action: #selector(tapSaveButton), for: UIControl.Event.touchUpInside)
        
        view.addSubview(saveButton)
        
        let constraints = [
            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 30),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            saveButton.widthAnchor.constraint(equalTo: wordCountLabel.widthAnchor),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        constraints.forEach { constraint in
            constraint.isActive = true
        }
    }
    
    @objc func tapSaveButton() {
        let vc = AddCardsViewController()
        vc.discriptionString = textView.text
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setUpLabel() {
        wordCountLabel.text = "最大文字数\(maxWordCount - textView.text.count)/\(maxWordCount)"
        wordCountLabel.translatesAutoresizingMaskIntoConstraints = false
        wordCountLabel.textAlignment = .center
        view.addSubview(wordCountLabel)
        
        let constraints: [NSLayoutConstraint] = [
            wordCountLabel.topAnchor.constraint(equalTo:view.topAnchor, constant: 20),
            wordCountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            wordCountLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            wordCountLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
}

extension AddDescriptionViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let existingLines = textView.text.components(separatedBy: .newlines)
        let newLines = text.components(separatedBy: .newlines)
        let linesAfterChange = existingLines.count + newLines.count - 1
        return linesAfterChange <= 3 && textView.text.count + (text.count - range.length) <= maxWordCount
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.wordCountLabel.text = "最大文字数\(maxWordCount - textView.text.count)/\(maxWordCount)"
        wordCountLabel.backgroundColor = .white
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
