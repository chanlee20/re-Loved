//
//  ChatMessage.swift
//  reLoved
//
//  Created by 이찬 on 3/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import PhotosUI

struct ChatMessage : Identifiable {
    var id:String { documentId }
    
    let documentId, fromId, toId, text:String
    var images:[String]
    var image: UIImage?
    var timestamp: Timestamp
    init(documentId:String, data: [String: Any]){
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.images = data["images"] as? [String] ?? []
        self.image = nil
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
