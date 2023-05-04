//
//  ProfileViewModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/22/23.
//
import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject{
    @Published var loggedout = false
    @Published var auth = Auth.auth()
    @Published var db = Firestore.firestore()
    @Published var userUID = Auth.auth().currentUser?.uid ?? ""
    @Published var username = ""
    @Published var profileImage:Image? = nil
    @Published var imageUID:String = ""
    @Published var showModal = false
    @Published var userRating = 0.0
    init(){
        self.fetchUserData()
    }
    
    //fetch user information from firebase db
    func fetchUserData()  {
        
        
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
                    self.imageUID = data["image-uid"] as? String ?? "default"
                    self.userRating = data["user-rating"] as? Double ?? 2.5
                }
            }
            
            let imageRef = storageRef.child("profile/\(self.imageUID).jpg")
            
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image : \(error)")
                } else {
                    if let imageData = data {
                        if let uiImage = UIImage(data: imageData) {
                            self.profileImage = Image(uiImage: uiImage)
                        } else {
                            print("No image data found")
                        }
                    }
                }
            }
        }
    }
    
    
    
}
