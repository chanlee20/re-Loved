//
//  UserViewModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 4/1/23.
//

import Foundation

import Firebase
import FirebaseStorage
import FirebaseFirestore

final class UserViewModel: ObservableObject {
    @Published var posts = [PostModel]()
    public typealias blockCompletion = (Result<[String], Error>) -> Void
    let db = Firestore.firestore()
    let storage = Storage.storage()
    @Published var currentUserUID = Auth.auth().currentUser?.uid ?? ""
    func fetchBlockList(completion: @escaping blockCompletion){
        
        var result = [""]
        
        let userRef = db.collection("users").document(self.currentUserUID)
        
        let task = userRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                completion(.failure("error" as! Error))
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    
                    result = data["blockedList"] as? [String] ?? [""]
                    
                }
            }
            completion(.success(result))
            
            
        }
        task
    }
    
}
