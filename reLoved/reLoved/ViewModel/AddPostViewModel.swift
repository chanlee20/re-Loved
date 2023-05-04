//
//  AddPostViewModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/22/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore


final class AddPostViewModel: ObservableObject{
    @Published var itemName = ""
    @Published var itemDescription = ""
    @Published var price = 0
    @Published var location = ""
    @Published var category = "stuff"
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    //add post to firebase db
    func post(image: UIImage){
        
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        let postUID = UUID().uuidString
        let storageRef = storage.reference()
        let timestamp = Timestamp(date: Date())
        
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        let fileRef = storageRef.child("images/\(postUID).jpg")
        let uploadTask = fileRef.putData(imageData,metadata: nil){
            metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                
            }
        }
        
        
        let timestamp_post = Timestamp()
        // add it to post database
        db.collection("posts").document(postUID).setData([
            "uid": postUID,
            "name": itemName,
            "desc": itemDescription,
            "image-uid": postUID,
            "price": String(price),
            "location": location,
            "category": category,
            "user": userUID,
            "timestamp": timestamp,
            "status": "On Sale"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            
        }
        
        
        // add it to user array
        db.collection("users").document(userUID).updateData([
            "posted": FieldValue.arrayUnion([postUID])
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            
        }
        
        
    }
    
}

