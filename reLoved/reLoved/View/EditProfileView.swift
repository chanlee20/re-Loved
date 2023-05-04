//
//  EditProfileModalView.swift
//  reLoved
//
//  Created by Jiwoo Seo on 2/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import PhotosUI

struct EditProfileView: View {
    @StateObject var viewModel = EditProfileViewModel()
    @StateObject var imagePicker = ImagePicker()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    
    
    
    var body: some View {
        VStack {
            ZStack {
                VStack{
                    VStack(spacing: 100){
                        ZStack{
                            if let image = imagePicker.image{
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            PhotosPicker( selection: $imagePicker.imageSelection){
                                Label("Change Profile Photo", systemImage: "photo")
                                
                            }.tint(.gray)
                                .controlSize(.large)
                                .buttonStyle(.borderedProminent)
                        }
                        
                    }.frame(width: 300, height: 300)
                        .border(.gray)
                    
                    
                    VStack(alignment: .leading){
                        Text("Username").padding(.top, 10)
                    }
                    
                    VStack() {
                        TextField(viewModel.username, text: $viewModel.newUsername)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 300)
                            .padding(.bottom, 20)
                        
                        
                        Button(action: {viewModel.updateProfileInfo(image: imagePicker.imageData ?? UIImage())
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Submit")
                            
                                .bold()
                                .frame(width: 200, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(hex: 0x5F879D, alpha: 1))
                                )
                                .foregroundColor(Color(hex: 0xF3EEE2))
                        })
                        
                        Button(action: {
                            showAlert = true
                        }, label: {
                            Text("Delete Account")
                            
                                .bold()
                                .frame(width: 200, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(hex: 0xbcbcbc, alpha: 1))
                                )
                                .foregroundColor(Color(hex: 0xFFFFFF))
                        }).alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Do you want to delete your account?"),
                                primaryButton: .cancel(),
                                secondaryButton: .default(Text("Yes"), action: {
                                    viewModel.deleteAccount()
                                })
                            )
                        }
                    }
                    
                }
            }
        }
        .navigationTitle("Edit Profile")
        .toolbar(.hidden, for: .tabBar)
    }
    
    
    
    
    
}

struct EditProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
