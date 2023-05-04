//
//  profileView.swift
//  reLoved
//
//  Created by Jiwoo Seo on 2/10/23.
//

import SwiftUI
import Neumorphic

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var imagePicker = ImagePicker()
    
    var body: some View {
        content
        
    }
    var content: some View {
        
        ZStack {
            
            VStack{
                
                NavigationView {
                    ScrollView {
                        VStack {
                            
                            ZStack() {
                                
                                RoundedRectangle(cornerRadius: 20).fill(Color.Neumorphic.main).softOuterShadow()
                                
                                VStack{
                                    Text(viewModel.username).padding([.bottom, .top], 1).bold().font(.system(size: 36)).padding(.top, 20)
                                    
                                    if let profileImage = viewModel.profileImage {
                                        profileImage
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 200.0, height: 200.0)
                                            .clipped()
                                            .cornerRadius(100)
                                            .padding(.top, 20)
                                    } else {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .frame(width: 200.0, height: 200.0)
                                    }
                                    
                                    
                                    Text(viewModel.auth.currentUser?.email ?? "email not found")
                                        .padding([.bottom, .top], 1)
                                    HStack(spacing: 5){
                                        Image(systemName: "star.fill")
                                            .renderingMode(.template)
                                            .foregroundColor(Color(hex: "5F879D"))
                                        Text(String(viewModel.userRating))
                                    }.padding([.bottom, .top], 1)
                                    
                                    
                                    NavigationLink(destination: OnSaleView()) {
                                        Text("On Sale")
                                    }
                                    Spacer()
                                    
                                }.onAppear(perform: viewModel.fetchUserData)
                                    .navigationTitle("Your Profile")
                            }.frame(width: 300, height: 400)
                                .padding(.bottom, 15)
                            
                            NavigationLink(destination: EditProfileView()){
                                Text("Edit Profile")
                                    .bold()
                                    .frame(width: 200, height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(hex: 0x5F879D, alpha: 1))
                                    )
                                    .foregroundColor(Color(hex: 0xF3EEE2))
                            }
                            
                            Button(action: {loginViewModel.logout()}, label: {
                                Text("Log out")
                                    .bold()
                                    .frame(width: 200, height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(hex: 0xbcbcbc, alpha: 1))
                                    )
                                    .foregroundColor(Color(hex: 0xFFFFFF))
                            })
                            
                        }.padding(.init(top: 15, leading: 10, bottom: 10, trailing: 10))
                        
                        
                        
                    }
                }
                
                
                
            }.padding(.bottom, 20)
            
            
            
            
            
        }.toolbar(.visible, for: .tabBar)
        
    }
    
    
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
