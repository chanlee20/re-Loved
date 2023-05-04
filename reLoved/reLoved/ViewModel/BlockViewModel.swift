//
//  BlockViewModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 4/1/23.
//

import Foundation
import Collections
import Firebase
import FirebaseFirestore
import SwiftUI

final class BlockViewModel: ObservableObject{
    @Published var userUID = Auth.auth().currentUser?.uid ?? ""
    let db = Firestore.firestore()
    let storage = Storage.storage()
    @Published var recentSearches : [[String]] = []
    
    init(){
        
    }
    
    func blockThisUser(blockedUserUID: String) {
        
        
        
        db.collection("users").document(self.userUID).updateData([
            "blockedList": FieldValue.arrayUnion([blockedUserUID])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    
    
    
}
