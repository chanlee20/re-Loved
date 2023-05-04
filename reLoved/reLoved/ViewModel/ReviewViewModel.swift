//
//  ReviewViewModel.swift
//  reLoved
//
//  Created by 이찬 on 3/29/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class ReviewViewModel : ObservableObject {
    @Published var opponentUser = ""
    @Published var currentUser = ""
    @Published var userRating = 0.0
    @Published var totalReviews = 0.0
    
    private var opponentUserUID: String = ""
    private var itemUID: String = ""
    
    init(opponentUserUID: String, itemUID: String) {
        self.opponentUserUID = opponentUserUID
        self.itemUID = itemUID
        fetchCurrentUser()
    }
    
    let db = Firestore.firestore()
    
    func fetchCurrentUser() {
        guard let currentUserUID = Firebase.Auth.auth().currentUser?.uid else { return }
        db.collection("users").whereField("uid", isEqualTo: currentUserUID).getDocuments { querySnapShot, error in
            if let error = error {
                print(error)
            }
            guard let documents = querySnapShot?.documents else {return}
            if documents.count > 0 {
                self.currentUser = documents[0].data()["name"] as? String ?? "User"
            }
            else{
                self.currentUser = "User"
            }
        }
        
        db.collection("users").whereField("uid", isEqualTo: opponentUserUID).getDocuments { querySnapShot, error in
            if let error = error {
                print(error)
            }
            guard let documents = querySnapShot?.documents else {return}
            if documents.count > 0 {
                self.opponentUser = documents[0].data()["name"] as? String ?? "the opponent user"
            }
            else{
                self.opponentUser = "the opponent user"
            }
        }
        
    }
    
    func writeReview(review: String, rating: Int) {
        guard let currentUserUID = Firebase.Auth.auth().currentUser?.uid else { return }
        
        let reviewData: [String: Any] = [
            "review": review,
            "rating": rating,
            "reviewer": currentUserUID,
            "reviewed": opponentUserUID
        ]
        
        let reviewDocRef = db.collection("reviews").document(currentUserUID).collection(itemUID).document(opponentUserUID)
        reviewDocRef.setData(reviewData) { error in
            if let error = error {
                print("Error writing review: \(error)")
            } else {
                print("Review written successfully!")
            }
        }
        
        let reviewReceiveDocRef = db.collection("reviews").document(opponentUserUID ).collection(itemUID).document(currentUserUID)
        reviewReceiveDocRef.setData(reviewData){
            error in
            if let error = error {
                print("Error writing review: \(error)")
            } else {
                print("Review written successfully!")
            }
        }
        
        updateUserRating(rating: rating)
        
        let userRef = db.collection("users").document(opponentUserUID)
        userRef.updateData(["totalReviews": FieldValue.increment(Int64(1))])
        
        
    }
    
    func updateUserRating(rating: Int){
        let userRef = db.collection("users").document(opponentUserUID)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.userRating = data?["user-rating"] as? Double ?? 2.5
                self.totalReviews = data?["totalReviews"] as? Double ?? 0.0
                let newRating = ((self.userRating * Double(self.totalReviews)) + Double(rating)) / Double(self.totalReviews + 1)
                let roundedRating = newRating.rounded(toPlaces: 1)
                
                userRef.updateData(["user-rating": roundedRating])
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
