//
//  EditProfileViewModel.swift
//  reLoved
//
//  Created by Jiwoo Seo on 2/25/23.
//

import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI

final class EditProfileViewModel: ObservableObject {
    @Published var newUsername = ""
    @Published var newEmail = ""
    @Published var curHeight = 700;
    @Published var username = ""
    @Published var imageUID = ""
    @Published var newImageUID = ""
    @Published var currImage: UIImage? = nil
    @Published var hasNewPhoto = false
    @Published var isUserLoggedIn = false;
    
    
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let storageRef = Storage.storage().reference()
    
    
    init() {
        fetchUserData()
    }
    
    
    //fetch user information from firebase db
    func fetchUserData()  {
        
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        
        
        // fetch user's username from firestore
        let docRefUsers = db.collection("users").document(userUID)
        let storageRef = Storage.storage().reference()
        
        
        docRefUsers.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    self.username = data["name"] as? String ?? ""
                    self.newUsername = data["name"] as? String ?? ""
                    self.imageUID = data["image-uid"] as? String ?? "default"
                    print("data", self.username, "    ", self.imageUID)
                }
            }
            
            //             fetch current profile image data from storage
            let imageRef = storageRef.child("profile/\(self.imageUID).jpg")
            
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image : \(error)")
                } else {
                    if let imageData = data {
                        if let uiImage = UIImage(data: imageData) {
                            self.currImage = uiImage
                        } else {
                            print("No image data found")
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    func deleteAccount() {
        print("delete account")
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        
        
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    // An error occurred
                    print(error.localizedDescription)
                } else {
                    // User deleted
                }
            }
        }
        
        
        self.db.collection("users").document(userUID).delete { error in
            if let error = error {
                print(error)
            }
        }
        
        
        
    }
    
    
    func updateProfileInfo(image: UIImage) {
        
        // FIX HERE: if newUsername == "" or " ", should not be able to updated
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        //        let postUID = UUID().uuidString
        
        // update profile image
        var imageData = self.currImage?.jpegData(compressionQuality: 0.3)
        if let newImage = image.jpegData(compressionQuality: 0.3) {
            imageData = newImage
            hasNewPhoto = true
        } else {
            print("no image was uploaded")
            hasNewPhoto = false
        }
        
        
        if hasNewPhoto {
            let fileRef = storageRef.child("profile/\(userUID).jpg")
            let _uploadTask = fileRef.putData((imageData ?? UIImage(named: "plushie")?.jpegData(compressionQuality: 0.3))! ,metadata: nil){
                metadata, error in
                if let error = error {
                    print("Error uploading image: \(error)")
                    
                }
            }
            // update username
            db.collection("users").document(userUID).updateData([
                "name": newUsername,
                "image-uid": userUID
            ]) {
                err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    self.username = self.newUsername
                    print("Document successfully updated!")
                    
                }
                
            }
        } else {
            // update username
            db.collection("users").document(userUID).updateData([
                "name": newUsername
            ]) {
                err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    self.username = self.newUsername
                    print("Document successfully updated!")
                    
                }
                
            }
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
}
