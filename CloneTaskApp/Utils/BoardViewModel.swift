//
//  boardViewModel.swift
//  CloneTaskApp
//
//  Created by 小川慶汰 on 2021/09/23.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

struct board {
    var boardID: String
    var boardName: String
}

struct list {
    var listID: String
    var listName: String
    var tasks: [task]
}

struct  listData {
    var listID: String
    var boardID: String
    var listName: String
}

class BoardViewModel {
    
    static let sharedBoardViewModel = BoardViewModel()
    
    var boards: [board] = []
    var listItems: [listData] = []
    
    var currentBoard: board?
//    var currentList: list?
    var currentCard: task?
    
    func getBoardName()-> Observable<[board]> {
        return Observable<[board]>.create { (observer) -> Disposable  in
            Firestore.firestore().collection("boards").getDocuments{ [self](snapShots, error) in
                if let error = error {
                    observer.onError(fatalError("\(error)"))
                }
                else {
                    for document in snapShots!.documents {
                        let boardData = board(boardID: document.documentID, boardName: document.data()["boardName"] as! String)
                        boards.append(boardData)
                    }
                    observer.onNext(boards)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func getBoardData(boardId: String) {
        Firestore.firestore().collection("boards").document(boardId).getDocument { snapShot, error in
            if let error = error  {
                print("yatta-annte")
                print(NSError())
            }
            else {
                let getData = snapShot?.data()
                self.currentBoard = board(boardID: snapShot!.documentID, boardName: getData!["boardName"] as! String)
                print("すごい", self.currentBoard)
            }
        }
    }
    
    
    func getBoardDetail(boardId: String)-> Observable<[list]> {
        return Observable<[list]>.create { (observer) -> Disposable in
            Firestore.firestore().collection("lists").whereField("boardID", isEqualTo: boardId).getDocuments{ [self](snapShots, error) in
                if let error = error {
                    observer.onError(fatalError("\(error)"))
                }
                else {
                    var countflg = 0
                    var listDatas: [list] = []
                    for document in snapShots!.documents {
                        getCardName(listId: document.documentID).subscribe {  value in
                            let listData = list(listID: document.documentID, listName: document.data()["listName"] as! String, tasks: value)
                            listDatas.append(listData)
                            countflg+=1
                            if snapShots?.count == countflg {
                                observer.onNext(listDatas)
                                //self.getBoardData(boardId: boardId)
                            }
                        } onError: { error in
                            print("エラーです")
                        }
                    }
                    self.getCurrentListData(boardID: boardId)
                }
            }
            return Disposables.create()
        }
    }
    
    func getCardName(listId: String)-> Observable<[task]> {
        return Observable<[task]>.create{ (observer) -> Disposable in
            Firestore.firestore().collection("cards").whereField("listID", isEqualTo: listId).getDocuments{(snapShots, error) in
                if let error = error {
                    observer.onError(fatalError("\(error)"))
                }
                else{
                    var cards: [task] = []
                    for document in snapShots!.documents {
                        let cardData = task(taskId: document.documentID, listID: listId, taskName: document.data()["cardName"] as! String, taskDescrption: document.data()["taskDescription"] as! String, startDay: document.data()["startDay"] as! String, deadlineDay: document.data()["deadlineDay"] as! String)
                        cards.append(cardData)
                    }
                    observer.onNext(cards)
                }
                
            }
        return Disposables.create()
        }
    }
    
    func getCardDetail(cardName: String)-> Observable<task> {
        return Observable<task>.create{(observer) -> Disposable in
            Firestore.firestore().collection("cards").whereField("cardName", isEqualTo: cardName).getDocuments{(snapShots, error) in
                if let error = error {
                    observer.onError(fatalError("\(error)"))
                }
                else {
                    for document in snapShots!.documents {
                        let cardData = task(taskId: document.documentID, listID: document.data()["listID"] as! String, taskName: document.data()["cardName"] as! String, taskDescrption: document.data()["taskDescription"] as! String, startDay: document.data()["startDay"] as! String, deadlineDay: document.data()["deadlineDay"] as! String)
                        self.currentCard = cardData
                        observer.onNext(cardData)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func changeCardName(card: task, newName: String)-> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            Firestore.firestore().collection("cards").document(card.taskId).setData(["cardName" : newName, "deadlineDay" : card.deadlineDay, "listID" : card.listID, "startDay" :card.startDay, "taskDescription" : card.taskDescrption ], merge: true)
            { error in
                if let error = error {
                    print("Error writing document: \(error)")
                    observer.onError(NSError())
                }
                else {
                    observer.onNext("変更を保存しました")
                }
            }
            return Disposables.create()
        }
    }
    
    func changeCardDay(startDay: String, endDay: String, card: task)-> Observable<String> {
        return Observable<String>.create{ (Observable) -> Disposable in
            Firestore.firestore().collection("cards").document(card.taskId).setData(["cardName" : card.taskName, "deadlineDay" : endDay, "listID" : card.listID, "startDay" :startDay, "taskDescription" : card.taskDescrption ], merge: true)
                { error in
                if let error = error {
                    print("Error writing document: \(error)")
                    Observable.onError(NSError())
                }
                else {
                    Observable.onNext("変更を保存をしました")
                }
            }
            return Disposables.create()
        }
    }
    
    func changeCarddescription(description: String, card: task)-> Observable<String> {
        return Observable<String>.create { (Observable) -> Disposable in
            Firestore.firestore().collection("cards").document(card.taskId).setData(["cardName" : card.taskName, "deadlineDay" : card.deadlineDay, "listID" : card.listID, "startDay" :card.startDay, "taskDescription" : description ], merge: true)
                { error in
                if let error = error {
                    print("Error writing document: \(error)")
                    Observable.onError(NSError())
                }
                else {
                    Observable.onNext("変更を保存しました")
                }
 
            }
            return Disposables.create()
        }
    }
    
    func deleteItem(cardId: String)-> Observable<String> {
        return Observable<String>.create { (Observable) -> Disposable in
            Firestore.firestore().collection("cards").document(cardId).delete { error in
                if let error = error {
                    print("Error writing document: \(error)")
                    Observable.onError(NSError())
                }
                else {
                    Observable.onNext("削除しました")
                }
            }
            return Disposables.create()
        }
    }
    
    func getAllListInfo(boardID: String)-> Observable<[listData]> {
        return Observable<[listData]>.create{(observer) -> Disposable in
            Firestore.firestore().collection("lists").whereField("boardID", isEqualTo: boardID).getDocuments{(snapShots, error) in
                if let error = error {
                    observer.onError(fatalError("\(error)"))
                }
                else {
                    var listDataItems: [listData] = []
                    for document in snapShots!.documents {
                        let listData = listData(listID: document.documentID, boardID: document.data()["boardID"] as! String, listName: document.data()["listName"] as! String)
                        listDataItems.append(listData)
                    }
                    observer.onNext(listDataItems)
                }
            }
            return Disposables.create()
        }
    }
    
    func getCurrentListData(boardID: String){
        Firestore.firestore().collection("lists").whereField("boardID", isEqualTo: boardID).getDocuments{(snapShots, error) in
            if let error = error {
                print(fatalError("\(error)"))
            }
            else {
                self.listItems = []
                for document in snapShots!.documents {
                    let listData = listData(listID: document.documentID, boardID: document.data()["boardID"] as! String, listName: document.data()["listName"] as! String)
                    self.listItems.append(listData)
                }
            }
        }
    }
    
    func addCard(listID: String, cardName: String, startDay: String, deadlineDay: String, description: String)-> Observable<String> {
        return Observable<String>.create { (Observable) -> Disposable in
            Firestore.firestore().collection("cards").addDocument(data: [
                "cardName" : cardName,
                "deadlineDay" : deadlineDay,
                "listID" : listID,
                "startDay" : startDay,
                "taskDescription" : description
            ]){ err in
                if let error = err {
                    print("Error adding document: \(err)")
                }
                else {
                    Observable.onNext("保存しました")
                }
            }
            return Disposables.create()
        }
    }
    
    func addList(boardID: String, listName: String) ->  Observable<String> {
        return Observable<String>.create { (Observable) -> Disposable in
            Firestore.firestore().collection("lists").addDocument(data: [
                "boardID" : boardID,
                "listName" : listName
            ]) { err in
                if let error = err {
                    print("Error adding document: \(err)")
                }
                else {
                    Observable.onNext("保存しました")
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteList(listId: String)-> Observable<String> {
        return Observable<String>.create { (Observable) -> Disposable in
            Firestore.firestore().collection("lists").document(listId).delete { error in
                if let error = error {
                    print("Error writing document: \(error)")
                    Observable.onError(NSError())
                }
                else {
                    Firestore.firestore().collection("cards").whereField("listID", isEqualTo: listId).getDocuments { (snapshots, error) in
                        if let error = error {
                            print("Error writing document: \(error)")
                        }
                        else {
                            for document in snapshots!.documents {
                                Firestore.firestore().collection("cards").document(document.documentID).delete { error in
                                    if let error = error {
                                        print("Error writing document: \(error)")
                                    }
                                    else {
                                        Observable.onNext("削除しました")
                                    }
                                }
                            }
                        }
                    }
                    Observable.onNext("削除しました")
                }
            }
            return Disposables.create()
        }
    }
    
    func selectMoveCard(listTitle: String)-> Observable<String> {
        var listId = ""
        return Observable<String>.create { (observer)-> Disposable in
            Firestore.firestore().collection("lists").whereField("listName", isEqualTo: listTitle.prefix(listTitle.count - 3)).getDocuments { (snapshot, error) in
                if let error = error {
                    observer.onError(fatalError("\(error)"))
                }
                else {
                    for document in snapshot!.documents {
                        listId = document.documentID
                        Firestore.firestore().collection("cards").document(self.currentCard!.taskId).setData(["cardName" : self.currentCard!.taskName, "deadlineDay" : self.currentCard!.deadlineDay, "listID" : listId, "startDay" :self.currentCard!.startDay, "taskDescription" : self.currentCard!.taskDescrption ], merge: true) {
                            error in
                            if let error = error {
                                print("Error writing document: \(error)")
                                observer.onError(NSError())
                            }
                            else {
                                observer.onNext("変更を保存しました")
                            }
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func movingTask(listName: String, cardName: String)  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Firestore.firestore().collection("lists").whereField("listName", isEqualTo: listName).getDocuments { (snapshots, error) in
                
                if let error = error {
                    print("Error writing document: \(error)")
                    print("やったー１")
                }
                else {
                    for listDoscument in snapshots!.documents {
                        let listId = listDoscument.documentID
                        Firestore.firestore().collection("cards").whereField("cardName", isEqualTo: cardName).getDocuments{ (snapshots, error) in
                            
                            if let error = error {
                                print("Error writing document: \(error)")
                                print("やったー２")
                            }
                            else {
                                for cardDocument in snapshots!.documents {
                                    let cardDocumentId = cardDocument.documentID
                                    Firestore.firestore().collection("cards").document(cardDocumentId).updateData(["listID" : listId]){ error in
                                        if let error = error {
                                            print("Error writing document: \(error)")
                                        }
                                        else {
                                            print("成功", Date())
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func addboard(boarName: String) ->  Observable<String> {
        return Observable<String>.create { (Observable) -> Disposable in
            Firestore.firestore().collection("boards").addDocument(data: [
                "boardName" : boarName
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
                else {
                    Observable.onNext("保存しました")
                }
            }
            return Disposables.create()
        }
    }
    
    func getTaskFromDate(date: String)-> Observable<[task]> {
        return Observable<[task]>.create { (observer)-> Disposable in
            var taskList: [task] = []
            Firestore.firestore().collection("cards").whereField("deadlineDay", isEqualTo: date).getDocuments { (snapshots, error) in
                if let error = error {
                    print("Document data: \(error)")
                    observer.onError(error)
                }
                else {
                    for document in snapshots!.documents {
                        let taskData = task(taskId: document.documentID, listID: document.data()["listID"] as! String, taskName: document.data()["cardName"] as! String, taskDescrption: document.data()["taskDescription"] as! String, startDay: document.data()["startDay"] as! String, deadlineDay: document.data()["deadlineDay"] as! String)
                        taskList.append(taskData)
                    }
                    observer.onNext(taskList)
                }
            }
            return Disposables.create()
        }
    }
}
