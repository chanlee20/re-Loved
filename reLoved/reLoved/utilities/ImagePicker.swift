//
//  ImagePicker.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/12/23.
//
import SwiftUI
import PhotosUI
/**
 get image from the gallery
 */
@MainActor
class ImagePicker: ObservableObject {
    
    @Published var image: Image?
    @Published var imageData: UIImage?
    @Published var imageSelection: PhotosPickerItem? {
        didSet{
            if let imageSelection {
                Task{
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }
    
    
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws{
        do{
            if let data = try await imageSelection?.loadTransferable(type: Data.self){
                if let uiImage = UIImage(data:data){
                    self.image = Image(uiImage: uiImage)
                    
                }
                self.imageData = UIImage(data:data)
            }
            
        }catch{
            print(error.localizedDescription)
            image = nil
        }
    }
    
}
