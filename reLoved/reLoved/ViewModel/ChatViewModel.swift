//
//  ChatViewModel.swift
//  reLoved
//
//  Created by 이찬 on 3/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class ChatViewModel: ObservableObject{
    
    let db = Firestore.firestore()
    @Published var currentUserName = ""
    @Published var otherUserName = ""
    @Published var recentMessages = [RecentMessage]()
    @Published var profileImage:Image? = nil
    @Published var imageUID:String = ""
    
    init() {
        
        
    }
    
    func fetchOpponentProfilePic(profile_uid:String) -> Image {
        let storageRef = Storage.storage().reference()
        
        let imageRef = storageRef.child("profile/\(profile_uid).jpg")
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image : \(error)")
            } else {
                if let imageData = data {
                    if let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                    } else {
                        Image(systemName: "person.fill")
                    }
                }
            }
        }
        
        return Image(systemName: "person.fill")
        
    }
    
    func fetchOpponentUserName(toId:String) -> String {
        db.collection("users").whereField("uid", isEqualTo: toId).getDocuments { querySnapShot, error in
            if let error = error {
                print(error)
            }
            guard let documents = querySnapShot?.documents else {return}
            if documents.count > 0 {
                self.otherUserName = (documents[0].data()["name"] as? String ?? "")
            }
            else{
                self.otherUserName = "Invalid User"
            }
        }
        return self.otherUserName
    }
    
    func fetchCurrentUser() {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else {return}
        let storageRef = Storage.storage().reference()
        
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                self.currentUserName = userData?["name"] as? String ?? ""
                self.imageUID = userData?["image-uid"] as? String ?? "default"
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
    func fetchUserMessages(blockList : [String]) {
        guard let fromId = Firebase.Auth.auth().currentUser?.uid else {return}
        db.collection("recent_messages").document(fromId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { QuerySnapShot, error in
                if let error = error {
                    print(error)
                    return
                }
                QuerySnapShot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    if(!blockList.contains(change.document.data()["toId"] as? String ?? "")){
                        self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                    }
                    
                    
                })
            }
        
        db.collection("recent_messages").document(fromId).collection("messages").order(by: "timestamp")
        
        for (index, message) in self.recentMessages.enumerated() {
            self.recentMessages[index].level = index
        }
        
    }
}
