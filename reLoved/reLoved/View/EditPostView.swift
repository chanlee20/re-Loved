//
//  EditPostView.swift
//  reLoved
//
//  Created by 이찬 on 3/23/23.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct EditPostView: View {
    @State var postViewModel:EachPostViewModel?
    @StateObject var editViewModel = EditPostViewModel()

    @StateObject var imagePicker = ImagePicker()
    @Environment(\.presentationMode) var presentationMode

    
    init(postViewModel: EachPostViewModel? = nil) {
            self.postViewModel = postViewModel
            _editViewModel = StateObject(wrappedValue: EditPostViewModel(
                itemName: postViewModel?.name ?? "Name",
                itemDescription: postViewModel?.description ?? "Description",
                price: postViewModel?.price ?? "0",
                location: postViewModel?.location ?? " ",
                category: postViewModel?.category ?? "=",
                currImage: postViewModel?.image ?? UIImage(),
                itemUID: postViewModel?.itemUID ?? "itemUID missing"
            ))
        }
    
    var body: some View {
        ScrollView {
        ZStack {
            Color(hex: 0xF3EEE2, alpha: 1)
            
                VStack(spacing: 20){
                    // Image Picker
                    VStack(spacing: 100){
                        ZStack{
                            if let image = imagePicker.image{
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            PhotosPicker( selection: $imagePicker.imageSelection){
                                Label("Select a photo", systemImage: "photo")
                                
                            }.tint(.gray)
                                .controlSize(.large)
                                .buttonStyle(.borderedProminent)
                        }
                        
                    }.frame(width: 300, height: 300)
                        .border(.gray)
                    
                    
                    
                    TextField(postViewModel?.name ?? "Title", text: $editViewModel.itemName)
                        .foregroundColor(.black)
                        .textFieldStyle(.roundedBorder)
                    
                    Picker("Category", selection: $editViewModel.category) {
                        ForEach(Categories.allCases) { category in
                            Text(category.rawValue.capitalized)
                                .tag(category.rawValue)
                        }
                    }.pickerStyle(.segmented)
                    
                    TextField(postViewModel?.description ?? "Description", text: $editViewModel.itemDescription, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
                        .textFieldStyle(.roundedBorder)
                    TextField(postViewModel?.price ?? "Price ($)", text: $editViewModel.price)
                        .foregroundColor(.black)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Location", text: $editViewModel.location)
                        .foregroundColor(.black)
                        .textFieldStyle(.roundedBorder)
                    
                    
                        Button(action: {
                            editViewModel.editPost(image: (imagePicker.imageData ?? editViewModel.currImage) ?? UIImage(imageLiteralResourceName: "plushie"))
                            presentationMode.wrappedValue.dismiss()

                        }, label: {
                            Text("Save")
                                .bold()
                                .frame(width: 200, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(hex: 0x5F879D, alpha: 1))
                                )
                                .foregroundColor(Color(hex: 0xF3EEE2))
                        })
                        


                }.padding(.bottom, 30)
                    .frame(width: 350)
            }
        }.toolbar(.hidden, for: .tabBar)
    }
}

struct EditPostView_Previews: PreviewProvider {
    static var previews: some View {
        EditPostView()
    }
}
