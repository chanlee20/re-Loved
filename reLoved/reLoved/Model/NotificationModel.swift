//
//  NotificationModel.swift
//  reLoved
//
//  Created by 이찬 on 4/20/23.
//


import SwiftUI
import Firebase
import FirebaseFirestore

class NotificationModel: Identifiable{
    var content: String?
    var postID: String?
    let timeStamp:Date
    var postUser : String?
    
    init(data: [String: Any]){
        self.content = data["content"] as? String ?? ""
        self.postID = data["postID"] as? String ?? ""
        self.postUser = data["postUser"] as? String ?? ""
        if let timestamp = data["timestamp"] as? Timestamp {
            self.timeStamp = timestamp.dateValue()
        } else {
            self.timeStamp = Date()
        }
    }
    
    var timeago:String{
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timeStamp, relativeTo: Date())
    }
}
