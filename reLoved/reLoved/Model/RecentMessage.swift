//
//  RecentMessage.swift
//  reLoved
//
//  Created by 이찬 on 3/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct RecentMessage: Identifiable{
    var id : String {documentId}
    
    let documentId:String
    let text:String
    let fromId:String
    let toId:String
    let opponent_name:String
    let itemUID:String
    let timeStamp:Date
    let profileImageURL:String
    var level: Int
    init(documentId: String, data: [String:Any]) {
        self.documentId = documentId
        self.text = data["text"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.itemUID = data["itemUID"] as? String ?? ""
        if let timestamp = data["timestamp"] as? Timestamp {
            self.timeStamp = timestamp.dateValue()
        } else {
            self.timeStamp = Date()
        }
        self.opponent_name = data["opponent_name"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? "default"
        self.level = data["level"] as? Int ?? 0
    }
    
    var timeago:String{
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timeStamp, relativeTo: Date())
    }
    
}
