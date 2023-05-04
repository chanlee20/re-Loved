//
//  PostModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/18/23.
//

import Foundation

class PostModel: Identifiable, Decodable{
    
    
    var desc: String?
    var imageUID: String?
    var location: String?
    var name: String?
    var price: String?
    var uid: String?
    var user: String?
    var category: String?
    //var timestamp: Date?
    init(desc: String, imageUID: String, location: String, name: String, price: String, uid: String, user: String, category: String){
        self.name = name
        self.imageUID = imageUID
        self.desc = desc
        self.location = location
        self.price = price
        self.uid = uid
        self.user = user
        self.category = category
    }
    
    convenience init() {
        self.init(desc:"", imageUID:"", location:"", name:"", price:"", uid:"", user:"", category: "")
    }
}
