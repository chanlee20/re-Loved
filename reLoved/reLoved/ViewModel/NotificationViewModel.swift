//
//  NotificationViewModel.swift
//  reLoved
//
//  Created by 이찬 on 4/19/23.
//
import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class NotificationViewModel : ObservableObject{
    @Published var notifications: [NotificationModel] = []
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let userUID =  Auth.auth().currentUser?.uid
    init() {
        observePost()
    }
    
    func getNotification() {
        let notifRef = db.collection("notification").document(userUID ?? "").collection("notifObjects")
        notifRef.order(by: "timestamp")
        notifRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
//            if let documents = querySnapshot?.documents {
//                let notifications = documents.compactMap { document in
//                    let data = document.data();
//                    var notification = NotificationModel(data: data);
//                    self.notifications.append(notification);
//                }
//            }
            
            print(self.notifications)
        }
    }
    
    func observePost() {
        print("observing")
        db.collection("posts").addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            print("observing2")
            
            let documentChanges = snapshot?.documentChanges;
            if !(documentChanges?.isEmpty ?? true){
                let change = documentChanges?[0];
                if change?.type == .modified {
                    let postId = change?.document.documentID
                    let postUserId = change?.document.get("user") as? String
                    if postUserId != self.userUID {
                        self.db.collection("users").document(self.userUID ?? "").getDocument { snapshot, error in
                            if let error = error {
                                print(error)
                                return
                            }
                            if let likes = snapshot?.get("likes") as? [String], likes.contains(postId ?? "") {
                                let notificationRef = self.db.collection("notification").document(self.userUID ?? "").collection("notifObjects").document();
                                let data: [String: Any] = [
                                    "content": "The post you liked changed its status!",
                                    "timestamp": FieldValue.serverTimestamp(),
                                    "postID": postId,
                                    "postUser": postUserId
                                ]
                                notificationRef.setData(data)
                                self.notifications.append(NotificationModel(data: data))
                            }
                        }
                    }
                }
            }
        }
        getNotification()
    }
}
