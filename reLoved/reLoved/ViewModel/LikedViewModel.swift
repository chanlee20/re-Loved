//
//  LikedViewModel.swift
//  reLoved
//
//  Created by Jiwoo Seo on 3/4/23.
//
import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

final class LikedViewModel: ObservableObject {
    @Published var posts = [PostModel]()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    @Published var currentUserUID = Auth.auth().currentUser?.uid ?? ""
    @Published var likesList: [String] = []
    
    func fetchLikesListOfCurrentUser(){
        self.posts = []
        let docRef = db.collection("users").document(currentUserUID)
        
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let likes = document.data()?["likes"] as? [String] {
                    self.likesList = likes
                } else {
                    // handle the case when the likes array is nil or not of the expected type
                    print("no liked items")
                }
                print("Fetched Document: ")
                print(self.likesList)
                for p in self.likesList {
                    self.db.collection("posts").document(p).getDocument { (document, error) in
                        guard error == nil else {
                            print("error", error ?? "")
                            return
                        }
                        
                        if let document = document, document.exists {
                            let data = document.data()
                            if let data = data {
                                let temp = PostModel(desc: (String(describing: data["desc"] ?? "")),
                                                     imageUID: (String(describing: data["image-uid"] ?? "")),
                                                     location: (String(describing: data["loc"] ?? "")),
                                                     name: (String(describing: data["name"] ?? "")),
                                                     price:(String(describing: data["price"] ?? "")),
                                                     uid: (String(describing: data["uid"] ?? "")),
                                                     user: (String(describing: data["user"] ?? "")),
                                                     category: (String(describing: data["category"] ?? ""))
                                )
                                self.posts.append(temp)
                            }
                        }
                    }
                }
                
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    
}
