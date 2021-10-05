//
//  NextViewController.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/15.
//

import UIKit

struct menuItem {
    var isShown: Bool
    var menu: String
    var menuItemContens: [String]
}

class NextViewController: UIViewController {
    
    var tableView = UITableView()
    let textField = UITextField()
    let startDaylabel = UILabel()
    let endDaylabel = UILabel()
    let checkDescLabel = UILabel()
    
    var startDayLabelText: String?
    var endDayLabelText: String?
    var checkDescLabelText: String?
    var dismissflg: Bool?
    
    var cardDetail: task!
    
    let shareAlert = AlartUtil.sharedAlert
    let shareModel = BoardViewModel.sharedBoardViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        setUpNavigationItem()
        setUpTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    private let headerArray: [String] = ["カード名の取得(特定のカード名)", "クイックアクション", "期日の設定", "説明の追加"]
        private let firstMenu: [String] = ["カード名を編集する"]
        private let secondMenu: [String] = ["共有する"]
        private let thirdMenu: [String] = ["期日の設定"]
        private let forthMenu: [String] = ["説明の追加"]
    
    private lazy var courseArray = [
        menuItem(isShown: true, menu: self.headerArray[0], menuItemContens: self.firstMenu),
        menuItem(isShown: true, menu: self.headerArray[1], menuItemContens: self.secondMenu),
        menuItem(isShown: false, menu: self.headerArray[2], menuItemContens: self.thirdMenu),
        menuItem(isShown: false, menu: self.headerArray[3], menuItemContens: self.forthMenu)
    ]

    
    func setUpNavigationItem() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onTapBackButton(_:)))
        navigationItem.leftBarButtonItem = backButton
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(onTapEditButton(_:)))
        navigationItem.rightBarButtonItem = editButton
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)!, width: view.frame.maxX, height: view.frame.height - (navigationController?.navigationBar.frame.height)!)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    @objc func onTapBackButton(_ sender: Any) {
        let nav = self.navigationController
        let nextVC = nav!.viewControllers[(nav?.viewControllers.count)!-2] as! ViewController
        nextVC.lists = []
        nextVC.tasks = [:]
        nextVC.getList(documentId: shareModel.currentBoard!.boardID)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onTapEditButton(_ sender: UIBarButtonItem) {
        let nextVC = SettingModalViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        //present(nextVC, animated: true, completion: nil)
    }
    
    func setUpTextField(cell: UITableViewCell) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "カード名"
        textField.adjustsFontSizeToFitWidth = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 7
        cell.contentView.addSubview(textField)
        
        let constraints = [
            textField.topAnchor.constraint(equalTo: cell.textLabel!.bottomAnchor, constant: cell.contentView.frame.height/4),
            textField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -cell.contentView.frame.height/4),
            textField.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.5),
            textField.leftAnchor.constraint(equalTo: cell.textLabel!.leftAnchor)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
    func setUpButton(cell: UITableViewCell) {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("変更", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(tapEditButton), for: UIControl.Event.touchUpInside)
        cell.contentView.addSubview(button)
        
        let constraints = [
            button.leftAnchor.constraint(equalTo: cell.contentView.centerXAnchor, constant: view.frame.maxX/10),
            button.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -view.frame.maxX/10),
            button.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            button.heightAnchor.constraint(equalTo: textField.heightAnchor)
        ]
        
        constraints.forEach({
            $0.isActive = true
        })
    }
    
    @objc func tapEditButton() {
        guard let navTitle = navigationItem.title else {
            return
        }
        if textField.text == "" {
            shareAlert.showSingleAlert(vc: self, alertTitle: "未入力です", message: "タイトルには何か入力してください", okTitle: "OK") {_  in
                return
            }
        }
        shareAlert.showAlert(vc: self, alerttitle: "カード名の保存を行いますか？", message: "\(navTitle)から変更を行います", okTitle: "OK", cancelTitle: "しない", okHandler: {_ in
            self.changeCardName(newCardName: self.textField.text!)
            self.getDetailInfo(cardName: self.shareModel.currentCard!.taskName)
        }, cancelHandler: {_ in return }, compliteAction: nil)
    }
    
    func getDetailInfo(cardName: String) {
        shareModel.getCardDetail(cardName: cardName).subscribe { task in
            self.cardDetail = task
            if self.cardDetail.startDay != "" {
                self.startDayLabelText = "開始日: \(task.startDay)"
            }
            if self.cardDetail.deadlineDay != "" {
                self.endDayLabelText = "期日: \(task.deadlineDay)"
            }
            if self.cardDetail.taskDescrption != "" {
                self.checkDescLabelText = "✔️追加済み"
            }
        } onError: {_ in
            print("エラーが起こりました")
        }
    }
    
    func changeCardName(newCardName: String) {
        shareModel.changeCardName(card: cardDetail, newName: newCardName).subscribe { value in
            self.shareAlert.showSingleAlert(vc: self, alertTitle: value, message: "変更が保存されました", okTitle: "OK") {_ in
                self.navigationItem .title = self.textField.text
                self.tableView.headerView(forSection: 0)?.textLabel?.text = self.textField.text
                self.textField.text = ""
            }
        } onError: { Error in
            self.shareAlert.showSingleAlert(vc: self, alertTitle: "エラーが発生しました", message: "エラーが発生したため、変更が保存されませんでした", okTitle: "はい") {_ in
                return
            }
        }
    }
}


extension NextViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return courseArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if courseArray[section].isShown {
            return courseArray[section].menuItemContens.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = courseArray[indexPath.section].menuItemContens[indexPath.row]
        if indexPath.section == 0 {
            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                cell.textLabel?.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: cell.contentView.frame.height/10),
                cell.textLabel?.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: cell.contentView.frame.width/15),
                cell.textLabel?.bottomAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: -cell.contentView.frame.height/3),
                cell.textLabel?.rightAnchor.constraint(equalTo: cell.contentView.centerXAnchor, constant: -cell.contentView.frame.width/10)
            ]
            constraints.forEach({
                $0?.isActive = true
            })
            cell.textLabel!.adjustsFontSizeToFitWidth = true
            setUpTextField(cell: cell)
            setUpButton(cell: cell)
            return cell
        }
        else if indexPath.section == 2 {
            if startDayLabelText == nil {
                startDayLabelText = "開始日: 未設定"
            }
            startDaylabel.textAlignment = .right
            startDaylabel.text = startDayLabelText
            startDaylabel.backgroundColor = .white
            if endDayLabelText == nil {
                endDayLabelText = "期日: 未設定"
            }
            endDaylabel.backgroundColor = .white
            endDaylabel.textAlignment = .right
            endDaylabel.text = endDayLabelText
            cell.contentView.addSubview(startDaylabel)
            cell.contentView.addSubview(endDaylabel)
            
            startDaylabel.translatesAutoresizingMaskIntoConstraints = false
            endDaylabel.translatesAutoresizingMaskIntoConstraints = false
            
            let constraints = [
                startDaylabel.bottomAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: -cell.contentView.frame.height/10),
                startDaylabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: cell.contentView.frame.height/10),
                startDaylabel.leftAnchor.constraint(equalTo: cell.contentView.centerXAnchor, constant: -cell.contentView.frame.height/20),
                startDaylabel.rightAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: view.frame.width * 29/30),
                
                endDaylabel.topAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: cell.contentView.frame.height/10),
                endDaylabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -cell.contentView.frame.height/10),
                endDaylabel.leftAnchor.constraint(equalTo: cell.contentView.centerXAnchor, constant: -cell.contentView.frame.height/20),
                endDaylabel.rightAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: view.frame.width * 29/30)
            ]
            
            constraints.forEach({
                $0.isActive = true
            })
            return cell
        }
        
        if indexPath.section == 3 {
            checkDescLabel.textAlignment = .right
            if checkDescLabelText == nil {
                checkDescLabelText = "未追加"
            }
            checkDescLabel.text = checkDescLabelText
            checkDescLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(checkDescLabel)
            
            let constraints = [
                checkDescLabel.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor, constant: 0.25),
                checkDescLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                checkDescLabel.leftAnchor.constraint(equalTo: cell.contentView.centerXAnchor, constant: cell.contentView.frame.height/10),
                checkDescLabel.rightAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: view.frame.width * 29/30),
            ]
            
            constraints.forEach({
                $0.isActive = true
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if UIDevice.current.userInterfaceIdiom == .pad {
                shareAlert.showSingleAlert(vc: self, alertTitle: "iPadでは共有アクションは行えません", message: "更新を行うためにはiPhoneで行ってください", okTitle: "OK") {_ in
                    return
                }
            }
            else {
                let shareText = "Apple - Apple Watch"
                let shareWebsite = NSURL(string: "https://www.apple.com/jp/watch/")!

                let activityItems = [shareText, shareWebsite] as [Any]
                let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                
                present(activityVC, animated: true, completion: nil)
            }
        }
        else if indexPath.section == 2 {
            let nextVC = SettingDateViewController()
            nextVC.task = cardDetail
            navigationController?.pushViewController(nextVC, animated: true)
        }
        else if indexPath.section == 3 {
            let nextVC = SettingDescriptionViewController()
            nextVC.task = cardDetail
            navigationController?.pushViewController(nextVC, animated: true)
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 1 {
            return 0
        }
        else {
            return UITableViewCell().contentView.frame.height * 1.5
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return navigationItem.title
        }
        else {
            return courseArray[section].menu
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultheight = UITableViewCell().contentView.frame.height
        if indexPath.section == 0 {
            return defaultheight * 2
        }
        else if indexPath.section == 2 {
            return defaultheight * 1.5
        }
        return defaultheight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        if section == 0 || section == 1 {
            return headerView
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(headertapped(sender:)))
        headerView.addGestureRecognizer(gesture)
        headerView.tag = section
        return headerView
    }
    
    @objc func headertapped(sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else {
            return
        }
        courseArray[section].isShown.toggle()

        tableView.beginUpdates()
        tableView.reloadSections([section], with: .automatic)
        tableView.endUpdates()
    }
    
}
