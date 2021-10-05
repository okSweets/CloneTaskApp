//
//  alarm.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/17.
//

import Foundation
import UIKit
import RxSwift

class AlartUtil {
    
    static let sharedAlert = AlartUtil()
    let disposeBag = DisposeBag()
    private let xxxx = PublishSubject<Int>()
    var zzzz: Observable<Int> {
        return xxxx
    }
    
    
    func showAlert(vc: UIViewController, alerttitle: String, message: String, okTitle: String, cancelTitle: String, okHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?, compliteAction: (() -> Void)?) {
        let alert = UIAlertController(title: alerttitle, message: message, preferredStyle: UIAlertController.Style.alert)
        
       let okAction: UIAlertAction = UIAlertAction(title: okTitle, style: UIAlertAction.Style.default,handler: okHandler)
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.cancel, handler: cancelHandler)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: compliteAction)
    }
    
    func showSingleAlert(vc: UIViewController, alertTitle: String, message: String, okTitle: String, okHandler: ((UIAlertAction)-> Void)?) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertController.Style.alert)
        let singleAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
        
        alert.addAction(singleAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithData(vc: UIViewController, alerttitle: String, message: String, okTitle: String, cancelTitle: String, okHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?, compliteAction: (() -> Void)?) {
        let alert = UIAlertController(title: alerttitle, message: message, preferredStyle: UIAlertController.Style.alert)
       let okAction: UIAlertAction = UIAlertAction(title: okTitle, style: UIAlertAction.Style.default,handler: okHandler)
        //self.xxxx.onNext(5)
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.cancel, handler: cancelHandler)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: compliteAction)
    }

}
