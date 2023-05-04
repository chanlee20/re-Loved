//
//  ContentView.swift
//  reLoved
//
//  Created by 이찬 on 2/5/23.
//

import SwiftUI
import Firebase

struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginView()
    }
}

struct LoginView: View{
    @StateObject var viewModel = LoginViewModel()
    @State private var showEmailAlert = false
    @State private var showPassAlert = false
    var body: some View{
        //navigation view to use navigation link at line 75
        NavigationView(content: {
            if viewModel.isUserLoggedIn {
                MainView()
            }
            else{
                content
            }
        })
    }
    
    var content: some View {
        ScrollView {
            
            Color(hex: 0xF3EEE2, alpha: 1)
            ZStack{
                
                VStack{
                    Image("reLoved")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth)
                        .padding(.vertical, 40)
                        .accessibility(identifier: "img")
                    VStack{
                        VStack(alignment: .leading) {
                            Text("Email")
                                .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                                .font(.system(size: 15))
                                .padding(.bottom, 0)
                            TextField("Email", text: $viewModel.email)
                                .textFieldStyle(.roundedBorder)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.red, lineWidth: showEmailAlert ? 2 : 0)
                                )
                                .padding(.bottom, 15)
                                .frame(height: 30)
                            
                            Text("Password")
                                .font(.system(size: 15))
                                .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                                .padding(.top, 20)
                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(.roundedBorder)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.red, lineWidth: showPassAlert ? 2 : 0)
                                )
                                .padding(.bottom, 15)
                                .frame(height: 30)
                        }
                        
                        
                        
                        Button(action: {
                            if(!$viewModel.email.isNotEmpty.wrappedValue || !$viewModel.password.isNotEmpty.wrappedValue
                            ){
                                
                                
                                if(!$viewModel.email.isNotEmpty.wrappedValue){
                                    showEmailAlert = true
                                }
                                else{
                                    showEmailAlert = false
                                }
                                if(!$viewModel.password.isNotEmpty.wrappedValue){
                                    print("nil val")
                                    showPassAlert = true
                                    
                                }
                                else{
                                    showPassAlert = false
                                }
                                
                                return
                            }
                            viewModel.login()
                        }, label: {
                            Text("Sign In")
                                .bold()
                                .frame(width: 200, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(hex: 0x5F879D, alpha: 1))
                                )
                                .foregroundColor(Color(hex: 0xF3EEE2, alpha: 1))
                        }).alert(isPresented: ($viewModel.isUserNeedsVerification)) {
                            return Alert(title: Text("Email is not verified"), message: Text("Verify your email"), dismissButton: .default(Text("OK")))
                        }
                        .accessibilityIdentifier("Sign In")
                            .padding(.top)
                            .padding(.bottom, 15)
                            .offset(y: 40)
                            
                        NavigationLink(destination: SignupView(), label: {Text("Don't have an account?")})
                            .offset(y: 30)
                            .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                        
                    }
                }
                .frame(width: 300)
                Spacer()
            }
            
            //every time screen appears check if the user has already logged in
            .onAppear{
                viewModel.checkUserLoggedIn()
            }
        }.background(Color(hex: 0xF3EEE2, alpha: 1))
        
        
    }
    
}
