//
//  EachReviewViewModel.swift
//  reLoved
//
//  Created by 이찬 on 3/29/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore


class EachReviewViewModel : ObservableObject {
    @Published var rating: Int = 0
    @Published var review: String = ""
    @Published var reviewer: String = ""
    private var opponentUserUID: String = ""
    private var itemUID: String = ""
    
    init(opponentUserUID: String, itemUID:String) {
        self.opponentUserUID = opponentUserUID
        self.itemUID = itemUID
        fetchReview()
    }
    
    let db = Firestore.firestore()
    
    func fetchReview() {
        guard let currentUserUID = Firebase.Auth.auth().currentUser?.uid else { return }
        print(opponentUserUID)
        print(itemUID)
        let docRef = db.collection("reviews").document(currentUserUID).collection(itemUID).document(opponentUserUID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document data is available in document.data() dictionary
                let data = document.data()
                self.rating = data?["rating"] as? Int ?? 0
                self.review = data?["review"] as? String ?? ""
                self.reviewer = data?["reviewer"] as? String ?? ""
            } else {
                print("Document does not exis33t")
            }
        }
    }
    
}
