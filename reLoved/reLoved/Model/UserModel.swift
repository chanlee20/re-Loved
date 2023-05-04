//
//  UserModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/22/23.
//

import Foundation

class UserModel: Identifiable, Decodable{
    
    var name: String?
    var uid: String?
    var image_uid: String?
    
    init(name: String, image_uid: String, uid: String){
        self.name = name
        self.image_uid = image_uid
        self.uid = uid
    }
}

