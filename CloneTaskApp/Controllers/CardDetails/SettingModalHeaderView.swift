//
//  SettingModalHeaderView.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/17.
//

import UIKit

class SettingModalHeaderView: UIView {
    
    let dissmissButton = UIButton()
    var dismissDelegate: dismissDelegate?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        //setUpButton(button: dissmissButton, fromRightAnchor: frame.maxX - 70, fromLeftAnchor: 30, buttonTitle: "✖️")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpButton(button: UIButton, fromRightAnchor: CGFloat, fromLeftAnchor: CGFloat, buttonTitle: String) {
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onTapCancelButton), for: UIControl.Event.touchUpInside)
        
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
    
    @objc func onTapCancelButton() {
        dismissDelegate?.dismissFunction()
    }
    

}
