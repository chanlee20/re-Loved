//
//  ProfileImageView.swift
//  reLoved
//
//  Created by 이찬 on 3/20/23.
//

import SwiftUI
import FirebaseFirestore
import Firebase


struct ProfileImageView: View {
    let profileImageURL: String
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .onAppear {
                    fetchProfileImage()
                }
        }
    }
    
    private func fetchProfileImage() {
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("profile/\(profileImageURL).jpg")
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image : \(error)")
            } else {
                if let imageData = data {
                    if let uiImage = UIImage(data: imageData) {
                        self.image = uiImage
                    }
                }
            }
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(profileImageURL: "default")
    }
}
