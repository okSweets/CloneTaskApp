//
//  MoveToCardHeaderView.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/17.
//

import UIKit

class MoveToCardHeaderView: UIView {
    
    let titleLable = UILabel()
    let dissmissButton = UIButton()
    var dismissDelegate: dismissFromEditMoveBoaed?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        if UIDevice.current.userInterfaceIdiom == .phone {
            setUpButton(button: dissmissButton, fromRightAnchor: frame.maxX - 70, fromLeftAnchor: 30, buttonTitle: "✖️")
        }
        dissmissButton.addTarget(self, action: #selector(onTapSaveButton), for: UIControl.Event.touchUpInside)
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLabel() {
        titleLable.text = "カードの移動"
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLable)
        
        let constraints: [NSLayoutConstraint] = [
            titleLable.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLable.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            titleLable.widthAnchor.constraint(equalTo: widthAnchor, multiplier:  0.3),
            titleLable.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
    func setUpButton(button: UIButton, fromRightAnchor: CGFloat, fromLeftAnchor: CGFloat, buttonTitle: String) {
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        
        let constraints: [NSLayoutConstraint] = [
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: fromRightAnchor),
            button.leftAnchor.constraint(equalTo: leftAnchor, constant: fromLeftAnchor)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
    @objc func onTapSaveButton() {
        dismissDelegate?.dismissFromEditMove()
    }

}
