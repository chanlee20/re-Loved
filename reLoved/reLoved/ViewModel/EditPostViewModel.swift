//
//  EditPostViewModel.swift
//  reLoved
//
//  Created by 이찬 on 3/23/23.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore


final class EditPostViewModel: ObservableObject{
    @Published var itemName = ""
    @Published var itemDescription = ""
    @Published var price = ""
    @Published var location = ""
    @Published var category = ""
    let db = Firestore.firestore()
    let storage = Storage.storage()
    @Published var currImage: UIImage? = nil
    @Published var hasNewPhoto = false
    @Published var itemUID = ""
    
    init(itemName: String = "", itemDescription: String = "", price: String = "", location: String = "", category: String = "", currImage:UIImage = UIImage(), itemUID:String = "") {
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.price = price
        self.category = category
        self.location = location
        self.currImage = currImage
        self.itemUID = itemUID
    }
    //add post to firebase db
    func editPost(image: UIImage) {

            let storageRef = storage.reference()

            var imageData = self.currImage?.jpegData(compressionQuality: 0.3)
            if let newImage = image.jpegData(compressionQuality: 0.3) {
                imageData = newImage
                hasNewPhoto = true
            } else {
                print("no image was uploaded")
                hasNewPhoto = false
            }

        if hasNewPhoto {

            let fileRef = storageRef.child("images/\(itemUID).jpg")
            if let imageData = imageData {
                _ = fileRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        print("Error uploading image: \(error)")
                    }
                }
            } else {
                // imageData is nil
            }


        }
        
           


        db.collection("posts").document(self.itemUID).updateData([
                "name": itemName,
                "desc": itemDescription,
                "price": price,
                "location": location,
                "category": category,
                // Add any other fields that you want to update here
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
            }

        }

}
