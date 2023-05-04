//
//  CardViewModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/25/23.
//

import Foundation

import Firebase
import FirebaseStorage
import FirebaseFirestore


class CardViewModel: ObservableObject {
    @Published var image: UIImage?
    var post: PostModel
    @Published var isLoading = false
    
    init(post: PostModel) {
        self.post = post
        downloadImage()
    }
    
    func downloadImage() {
        guard let imageUID = post.imageUID else { return }
        let storageRef = Storage.storage().reference().child("images/\(imageUID).jpg")
        isLoading = true
        storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                } else if let data = data, let uiImage = UIImage(data: data) {
                    self.image = uiImage
                }
            }
        }
    }
}
