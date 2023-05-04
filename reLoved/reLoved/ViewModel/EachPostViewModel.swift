//
//  EachPostViewModel.swift
//  reLoved
//
//  Created by Jiwoo Seo on 3/4/23.
//
import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

final class EachPostViewModel: ObservableObject{
    public typealias postCompletion = (Result<[String], Error>) -> Void
    @Published var category = ""
    @Published var description = ""
    @Published var image = UIImage()
    @Published var location = ""
    @Published var name = ""
    @Published var price = ""
    @Published var userUID = ""
    @Published var username = ""
    @Published var itemUID = ""
    @Published var profileImage:Image? = nil
    @Published var currentUserUID = Auth.auth().currentUser?.uid ?? ""
    @Published var isLiked = false
    @Published var imageUID:String = ""
    @Published var userRating = 2.5
    @Published var post_status = ""
    @Published var isLoading = false
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    func updateStatus(status:String, itemUID:String) {
        let postsRef = db.collection("posts")
        postsRef.document(itemUID).updateData([
            "status": status
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated.")
            }
        }
    }
    
    func fetchByID(itemUID: String, completion: @escaping postCompletion){
      
        var result = ["", ""]
        let docRefUsers = db.collection("posts").document(itemUID)
        _ = db.collection("users")
        
        let task: Void = docRefUsers.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                completion(.failure(NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "error"])))
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    
                    result = [data["name"] as? String ?? "", data["user"] as? String ?? ""]
                    
                }
            }
               completion(.success(result))
    
            
        }
        task
    }
    func fetch(itemUID:String) {
        print(itemUID)
        isLoading = true
        let docRefUsers = db.collection("posts").document(itemUID)
        let userRef = db.collection("users")
        
        docRefUsers.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print("data", data)
                    self.category = data["category"] as? String ?? ""
                    self.description = data["desc"] as? String ?? ""
                    self.location = data["location"] as? String ?? ""
                    self.name = data["name"] as? String ?? ""
                    self.price = data["price"] as? String ?? ""
                    self.userUID = data["user"] as? String ?? ""
                    self.itemUID = itemUID
                    self.post_status = data["status"] as? String ?? ""
                }
            }
            
            userRef.document(self.userUID).getDocument { (document, error) in
                guard error == nil else {
                    print("error", error ?? "")
                    return
                }
                
                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        self.username = data["name"] as? String ?? ""
                        self.imageUID = data["image-uid"] as? String ?? "default"
                    }
                }
                let imageRef = self.storageRef.child("profile/\(self.imageUID).jpg")
                
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("Error downloading image : \(error)")
                    } else {
                        if let imageData = data {
                            self.isLoading = false
                            if let uiImage = UIImage(data: imageData) {
                                
                                self.profileImage = Image(uiImage: uiImage)
                            } else {
                                print("No image data found")
                            }
                        }
                    }
                }
            }
            
            self.isPostLikedByCurrentUser(itemUID: itemUID, completion: {(success) -> Void in
                if success {
                    print("liked: true")
                    self.isLiked = true
                }
                else {
                    print("liked: false")
                    self.isLiked = false
                }
            }
        )
            
            self.fetchCurrentUserRating()
            
            
        }
        
        
        let reference = storageRef.child("/images/\(itemUID).jpg")
        reference.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    self.image = image
                } else {
                    print("Error: downloaded image data is nil or cannot be converted to UIImage")
                }

            }
            
            
            
        }
    }
    

    
    func deletePost(itemUID: String) {
        let fileRef = storageRef.child("images/\(itemUID).jpg")
        
        // Delete the image file from Firebase Storage
        fileRef.delete { error in
            if let error = error {
                print(error)
                return
            }
            
            // Delete the post document from Firestore
            self.db.collection("posts").document(itemUID).delete { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func pullUpPost(itemUID: String){
        
        db.collection("posts").document(itemUID).updateData([
            "timestamp" : Timestamp()
            ]) { err in
                if let err = err {
                    print("Error pulling up document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
            }
    }
    
    
    func isPostLikedByCurrentUser(itemUID: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("users").document(currentUserUID)
        var likesList = [String]()
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                if let likes = document.data()?["likes"] as? [String] {
                    likesList = likes
                } else {
                    // handle the case when the likes array is nil or not of the expected type
                    print("no liked items")
                }
                if likesList.contains(itemUID) {
                    completion(true)
                }
                else{
                    completion(false)
                }
                
            }else{
                print("error reading document")
                completion(false)
                
            }

        }
        
    }
    
    func fetchCurrentUserRating() {
        let userRef = db.collection("users").document(self.userUID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userRating = document.get("user-rating") as? Double ?? 2.5
                // Do something with the user rating
            } else {
                print("Error retrieving document: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }

        
    func addCurrentPostToUserLikesArray(itemUID:String, clickedLike:Bool) {
            if clickedLike {
                db.collection("users").document(currentUserUID).updateData([
                    "likes": FieldValue.arrayUnion([itemUID])
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                    
                }
            } else {
                db.collection("users").document(currentUserUID).updateData([
                    "likes": FieldValue.arrayRemove([itemUID])
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                    
                }
            }
        }
    }


