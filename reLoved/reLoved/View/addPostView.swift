//
//  addPostView.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/20/23.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore


struct AddPostView: View {
    
    @StateObject var viewModel = AddPostViewModel()
    @StateObject var imagePicker = ImagePicker()
    @State var imagePicked = UIImage()
    @State private var showPhotoAlert = false
    @State private var showTitleAlert = false
    @State private var showDescAlert = false
    @State private var showPriceAlert = false
    @State private var showLocAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.red, lineWidth: showPhotoAlert ? 2 : 0)
                        )
                    
                    TextField("Title", text: $viewModel.itemName)
                        .foregroundColor(.black)
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.red, lineWidth: showTitleAlert ? 2 : 0)
                        )
                    
                    
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(Categories.allCases) { category in
                            Text(category.rawValue.capitalized)
                                .tag(category.rawValue)
                        }
                    }.pickerStyle(.segmented)
                    
                    TextField("Description...", text: $viewModel.itemDescription, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.red, lineWidth: showDescAlert ? 2 : 0)
                        )
                    TextField("Price", value: $viewModel.price, formatter: NumberFormatter())
                        .foregroundColor(.black)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.red, lineWidth: showPriceAlert ? 2 : 0)
                        )
                    
                    TextField("Location", text: $viewModel.location)
                        .foregroundColor(.black)
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.red, lineWidth: showLocAlert ? 2 : 0)
                        )
                    
                    Button(action: {
                        
                        if(!$viewModel.itemDescription.isNotEmpty.wrappedValue || !$viewModel.category.isNotEmpty.wrappedValue
                           || !$viewModel.itemName.isNotEmpty.wrappedValue || !$viewModel.location.isNotEmpty.wrappedValue){
                            if(!$viewModel.itemDescription.isNotEmpty.wrappedValue){
                                showDescAlert = true
                                
                            }else{
                                showDescAlert = false
                            }
                            
                            if(!$viewModel.itemName.isNotEmpty.wrappedValue){
                                showTitleAlert = true
                            }
                            else{
                                showTitleAlert = false
                            }
                            if(!$viewModel.location.isNotEmpty.wrappedValue){
                                print("nil val")
                                showLocAlert = true
                                
                            }
                            else{
                                showLocAlert = false
                            }
                            if (imagePicker.imageData == nil){
                                showPhotoAlert = true
                                
                            }
                            else{
                                showPhotoAlert = false
                            }
                            return
                        }
                        // we check that the imagePicker.imageData is not null at the top
                        viewModel.post(image: imagePicker.imageData!)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Post")
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
        }.toolbar(.hidden, for: .tabBar).onAppear(perform: {print("hi")}).onDisappear(perform: {print("bye")})
    }
    
}
struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
