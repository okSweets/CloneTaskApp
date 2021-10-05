//
//  ThirdViewHeader.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/15.
//

import UIKit

class ThirdViewHeader: UIView {

    var moveToDelegate: moveToDelegate?
    var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setUpButton()
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpLabel() {
        let label = UILabel()
        label.text = "ボード一覧"
        label.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            label.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -30),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30)
        ]
        
        addSubview(label)
        constraints.forEach({
            $0.isActive = true
        })
        
    }
    
    func setUpButton() {
        button = UIButton(frame: CGRect(x: frame.maxX - 60, y: frame.maxY/2 - 10, width: 45, height: 20))
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("追加", for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: UIControl.Event.touchUpInside)
        addSubview(button)
    }
    
    @objc func tapButton() {
        moveToDelegate?.moveTo()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
