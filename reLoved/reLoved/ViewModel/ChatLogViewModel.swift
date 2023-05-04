//
//  ChatLogViewModel.swift
//  reLoved
//
//  Created by 이찬 on 3/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import PhotosUI

class ChatLogViewModel: ObservableObject{
    @Published var count = 0
    @Published var chatMessages = [ChatMessage]()
    @Published var otherUserName = ""
    @Published var currentUserName = ""
    @Published var currentImageUid = ""
    @Published var opponentImageUid:String = ""
    @Published var postName = ""
    @Published var postImageUID = ""
    @Published var location = ""
    @Published var price = ""
    @Published var postImage : UIImage?
    @Published var userUID = ""
    @Published var currentUserUID = Firebase.Auth.auth().currentUser?.uid
    @Published var hasReviewed = false
    @Published var postUserUID:String
    @Published var hasFetchedPostImage = false
    private var itemUID: String
    
    let db = Firestore.firestore()
    
    init(postUserUID:String, itemUID:String) {
        self.postUserUID = postUserUID
        self.itemUID = itemUID
        fetchCurrentUser()
        fetchMessages()
        fetchPostInfo()
        getUserName(toId: self.postUserUID)
        checkExistingReview()
    }
    
    func checkExistingReview(){
        guard let currentUserUID = Firebase.Auth.auth().currentUser?.uid else { return }
        
        let reviewDocRef = db.collection("reviews").document(currentUserUID).collection(itemUID).document(postUserUID)
        reviewDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.hasReviewed = true
            } else {
                self.hasReviewed = false
                print("Document does not exist")
            }
        }
    }
    
    func fetchPostInfo() {
        let postRef = db.collection("posts").document(itemUID)
        
        postRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching post document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Error: post document not found")
                return
            }
            
            let data = document.data()
            if let name = data?["name"] as? String,
               let location = data?["location"] as? String,
               let userUID = data?["user"] as? String,
               let price = data?["price"] as? String {
                // Do something with the fetched data, such as updating your ViewModel's properties
                // or displaying it in your SwiftUI view
                self.postName = name
                self.postImageUID = self.itemUID
                self.location = location
                self.price = price
                self.userUID = userUID
            } else {
                print("Error: post document missing one or more required fields")
            }
        }
        
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("images/\(self.itemUID).jpg")
        print("imageUID : ", self.itemUID)
        
        
        guard postImage == nil, !hasFetchedPostImage else {
            return
        }
        
        hasFetchedPostImage = true
        
        fileRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            // handle error
            
            guard let imageData = data, let image = UIImage(data: imageData) else {
                print("Error: downloaded post image data is not a valid image format")
                return
            }
            
            DispatchQueue.main.async {
                self.postImage = image
            }
        }
        
        
    }
    
    func getUserName(toId:String){
        let storageRef = Storage.storage().reference()
        
        db.collection("users").whereField("uid", isEqualTo: toId).getDocuments { querySnapShot, error in
            if let error = error {
                print(error)
            }
            guard let documents = querySnapShot?.documents else {return}
            if documents.count > 0 {
                print(documents[0])
                self.otherUserName = documents[0].data()["name"] as? String ?? ""
                self.opponentImageUid = documents[0].data()["image-uid"] as? String ?? "default"
            }
            else{
                self.opponentImageUid = "default"
                self.otherUserName = "Invalid User"
            }
        }
    }
    
    
    func fetchMessages() {
        guard let fromId = Firebase.Auth.auth().currentUser?.uid else { return }
        db.collection("chats").document(fromId).collection(postUserUID).order(by: "timestamp")
            .addSnapshotListener { querySnapShot, err in
                if let err = err {
                    print(err)
                }
                querySnapShot?.documentChanges.forEach({
                    change in
                    if change.type == .added {
                        let data = change.document.data()
                        var chatMessage = ChatMessage(documentId: change.document.documentID, data: data)
                        
                        // check if message has an image
                        if let imageUrls = data["images"] as? [String] {
                            let group = DispatchGroup()
                            // download each image from Firebase Storage
                            for imageUrlString in imageUrls {
                                group.enter()
                                if let imageUrl = URL(string: imageUrlString) {
                                    URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                                        if let error = error {
                                            print(error)
                                            group.leave()
                                            return
                                        }
                                        if let imageData = data,
                                           let image = UIImage(data: imageData) {
                                            // create a new chat message with the downloaded image
                                            chatMessage.image = image
                                        }
                                        group.leave()
                                    }.resume()
                                }
                            }
                            
                            // wait for all images to download before appending the chat message to the array
                            group.notify(queue: DispatchQueue.main) {
                                self.chatMessages.append(chatMessage)
                                self.chatMessages.sort { (message1, message2) -> Bool in
                                    return message1.timestamp.compare(message2.timestamp) == .orderedAscending
                                }
                            }
                            
                        } else {
                            // no images, just add the text message to the array
                            self.chatMessages.append(chatMessage)
                        }
                    }
                })
            }
    }
    
    func handleSend(text: String, toId: String, itemUID: String, selectedImages: [UIImage]){
        if(text == "" && selectedImages.isEmpty){
            return
        }
        else{
            getUserName(toId: self.postUserUID)
            guard let fromId = Firebase.Auth.auth().currentUser?.uid else {return}
            
            let timestamp = Timestamp()
            var chatData = ["fromId": fromId, "toId": toId, "opponent_name": self.currentUserName, "itemUID": itemUID, "timestamp": timestamp] as [String : Any]
            
            if !text.isEmpty {
                chatData["text"] = text
            }
            
            if !selectedImages.isEmpty {
                var imageUrls = [String]()
                
                let dispatchGroup = DispatchGroup()
                
                for image in selectedImages {
                    dispatchGroup.enter()
                    
                    let imageName = UUID().uuidString
                    let storageRef = Storage.storage().reference().child("chat_images/\(imageName).jpg")
                    if let imageData = image.jpegData(compressionQuality: 0.5) {
                        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                            if let error = error {
                                print("Error uploading image: \(error.localizedDescription)")
                            } else {
                                storageRef.downloadURL { (url, error) in
                                    if let error = error {
                                        print("Error getting image URL: \(error.localizedDescription)")
                                    } else if let url = url {
                                        imageUrls.append(url.absoluteString)
                                        dispatchGroup.leave()
                                    }
                                }
                            }
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    chatData["images"] = imageUrls
                    
                    let document = self.db.collection("chats").document(fromId).collection(toId).document()
                    document.setData(chatData) { error in
                        if let error = error {
                            print(error)
                            return
                        }
                        self.count += 1
                        
                        self.persistRecentMessage(text: text, otherUserName: self.otherUserName, opponentImageUid: self.opponentImageUid, selectedImages: selectedImages)
                        
                    }
                    
                    let recipientDoc = self.db.collection("chats").document(toId).collection(fromId).document()
                    recipientDoc.setData(chatData) { error in
                        if let error = error {
                            print(error)
                            return
                        }
                    }
                }
            } else {
                if let text = chatData["text"] as? String, !text.isEmpty {
                    let document = db.collection("chats").document(fromId).collection(toId).document()
                    document.setData(chatData) { error in
                        if let error = error {
                            print(error)
                            return
                        }
                        self.count += 1
                        
                        self.persistRecentMessage(text: text, otherUserName: self.otherUserName, opponentImageUid: self.opponentImageUid, selectedImages: selectedImages)
                        
                    }
                    
                    let recipientDoc = db.collection("chats").document(toId).collection(fromId).document()
                    recipientDoc.setData(chatData) { error in
                        if let error = error {
                            print(error)
                            return
                        }
                    }
                }
            }
            
            
        }
    }
    
    
    
    func handlePhotoSend(selectedImages: [UIImage]) {
        //        for image in selectedImages {
        //            print(image.)
        //        }
        print("photo is sent")
    }
    
    func fetchCurrentUser(){
        guard let uid = Firebase.Auth.auth().currentUser?.uid else {return}
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                self.currentUserName = userData?["name"] as? String ?? ""
                self.currentImageUid = userData?["image-uid"] as? String ?? "default"
            }
        }
    }
    
    private func persistRecentMessage(text:String, otherUserName:String, opponentImageUid:String, selectedImages:[UIImage]) {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else {
            return
        }
        
        let document = db.collection("recent_messages").document(uid).collection("messages").document(self.postUserUID)
        
        let recipient_doc = db.collection("recent_messages").document(self.postUserUID).collection("messages").document(uid)
        
        let data = [
            "timestamp": Timestamp(),
            "text" : text,
            "fromId" : uid,
            "toId" : self.postUserUID,
            "itemUID": self.itemUID,
            "opponent_name": otherUserName,
            "profileImageURL": opponentImageUid
        ] as [String : Any]
        
        document.setData(data){
            error in if let error = error {
                print(error)
                return
            }
        }
        
        let recipient_data = [
            "timestamp": Timestamp(),
            "text" : text,
            "fromId" : self.postUserUID,
            "toId" : uid,
            "itemUID": self.itemUID,
            "opponent_name": self.currentUserName,
            "profileImageURL":self.currentImageUid
        ] as [String : Any]
        
        recipient_doc.setData(recipient_data){
            error in if let error = error {
                print(error)
                return
            }
        }
        
        
    }
}
