//
//  SearchHistoryViewModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 3/31/23.
//
import Collections
import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI

final class SearchHistoryViewModel: ObservableObject{
    @Published var userUID = Auth.auth().currentUser?.uid ?? ""
    let db = Firestore.firestore()
    let storage = Storage.storage()
    @Published var recentSearches : [[String]] = []
    
    init(){
        self.fetchRecentSearches()
    }
    
    func addPostToRecentSearches(itemName: String, itemUID:String, userUID: String, postUserUID: String) {
        let dataToAdd = [itemUID:[itemName,postUserUID]]
        
        
        db.collection("users").document(userUID).updateData([
            "recentSearches": FieldValue.arrayUnion([dataToAdd])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    
    func getPostNameFromPostID(){
        
        
    }
    
    
    func fetchRecentSearches()  {
        
        
        // fetch user's username from firestore
        let docRefUsers = db.collection("users").document(userUID)
        let docRefPosts = db.collection("posts")
        let storageRef = Storage.storage().reference()
        
        var PostIdData = [String]()
        
        docRefUsers.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    if (data["recentSearches"] == nil){
                        return
                    }
                    for item in data["recentSearches"] as? [[String:[String]]] ?? [["":[""]]]{
                        if (data["recentSearches"] == nil){
                            return
                        }
                        self.recentSearches.append([item.keys.first ?? "", item.values.first?[0] as? String ?? "", item.values.first?[1] as? String ?? ""])
                    }
                }
                
            }
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    
}
