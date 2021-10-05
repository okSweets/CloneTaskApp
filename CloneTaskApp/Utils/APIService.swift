//
//  APIService.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/23.
//

import Foundation
import Firebase
import RxSwift

class  APIService {
    
    static let sharedAPIService = APIService()
    
//    func getBoardName()-> Observable<board> {
//        return Observable<board>.create { observer in
//            Firestore.firestore().collection("boards").getDocuments{(snapShots, error) in
//                if let error = error {
//                    observer.onError(fatalError("\(error)"))
//                }
//                else {
//                    for document in snapShots!.documents {
//                        let boardData = board(boardID: , boardName: document.data()["boardName"] as! String)
//                        print("keita2", boardData)
//                        observer.onNext(boardData)
//                    }
//                    observer.onCompleted()
//                }
//            }
//            return Disposables.create()
//        }
//    }
}
