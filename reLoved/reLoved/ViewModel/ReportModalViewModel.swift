//
//  SwiftUIView.swift
//  reLoved
//
//  Created by 이찬 on 4/1/23.
//

import SwiftUI
import FirebaseFirestore
import Firebase

class ReportModalViewModel : ObservableObject {
    
    
    let db = Firestore.firestore()
    private var itemUID:String = ""
    private var postUserUID:String = ""
    
    init(itemUID: String, postUserUID:String) {
        self.itemUID = itemUID
        self.postUserUID = postUserUID
    }
    
    
    func writeReport(selectedOptions: Set<String>) {
        guard let currentUserUID = Firebase.Auth.auth().currentUser?.uid else { return }
        print(selectedOptions)
        print(currentUserUID)
        print(postUserUID)
        
        let userReportRef = db.collection("reports").document(itemUID).collection(currentUserUID)
        let userReportData: [String: Any] = [
            "reports": Array(selectedOptions),
            "post_owner": self.postUserUID,
            "reporter": currentUserUID,
        ]
        userReportRef.addDocument(data: userReportData) { error in
            if let error = error {
                print("Error writing user report: \(error)")
            } else {
                print("User report written successfully!")
            }
        }
        
        
    }
    
    
    
    
}
