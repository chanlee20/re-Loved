//
//  PostViewModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/22/23.
//
import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

final class PostViewModel: ObservableObject {
    @Published var posts = [PostModel]()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    @Published var currentUserUID = Auth.auth().currentUser?.uid ?? ""
    func fetchBlockList(){
        
    }
    //fetch posts from firebase
    func fetch(blockedList: [String]){
        
        // added to avoid duplicate postings on HomeView
        self.posts = []
        db.collection("posts").order(by: "timestamp", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let temp = PostModel(desc: (String(describing: document.data()["desc"] ?? "")),
                                         imageUID: (String(describing: document.data()["image-uid"] ?? "")),
                                         location: (String(describing: document.data()["loc"] ?? "")),
                                         name: (String(describing: document.data()["name"] ?? "")),
                                         price:(String(describing: document.data()["price"] ?? "")),
                                        uid: (String(describing: document.data()["uid"] ?? "")),
                                        user: (String(describing: document.data()["user"] ?? "")),
                                        category: (String(describing: document.data()["category"] ?? ""))
                        )
                    if (!blockedList.contains(String(describing: document.data()["user"] ?? "" ))){
                        self.posts.append(temp)
                    }
                    
                   
                }
            }
        }
    }
    

    
}
