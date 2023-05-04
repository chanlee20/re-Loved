//
//  SignupView.swift
//  reLoved
//
//  Created by 이찬 on 2/10/23.
//

import SwiftUI




struct SignupView : View{
    //state variables
    @StateObject var viewModel = SignUpViewModel()
    @State private var showEmailAlert = false
    @State private var showPassAlert = false
    @State private var showNameAlert = false
    @State private var showSecPassAlert = false
    

    
    @State private var showAlertBox = false

    
    var body: some View{
        if viewModel.isUserSignedUp {
            content
        }
        else{
            //if user didn't sign up yet
            content
        }
    }
    var content: some View {
        
        ScrollView {
            Color(hex: 0xF3EEE2, alpha: 1)
            ZStack{
                
                
                Color(hex: 0xF3EEE2, alpha: 1)
                VStack{
                    Image("reLoved")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth)
                        .padding(.bottom, 30)
                    VStack(alignment: .leading, spacing: 10){
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
                        
                        
                        Text("Name")
                            .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                            .font(.system(size: 15))
                            .padding(.bottom, 0)
                        
                        TextField("Name", text: $viewModel.name)
                            .textFieldStyle(.roundedBorder)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.red, lineWidth: showNameAlert ? 2 : 0)
                            )
                            .padding(.bottom, 15)
                            .frame(height: 30)
                        
                        
                        Text("Password (6 characters or longer)")
                            .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                            .font(.system(size: 15))
                            .padding(.bottom, 0)
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.red, lineWidth: showPassAlert ? 2 : 0)
                            )
                            .padding(.bottom, 15)
                            .frame(height: 30)
                        
                        
                        Text("Re-enter password")
                            .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                            .font(.system(size: 15))
                            .padding(.bottom, 0)
                        SecureField("Re-enter password", text: $viewModel.verifiedPassword)
                            .textFieldStyle(.roundedBorder)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.red, lineWidth: showSecPassAlert ? 2 : 0)
                            )
                            .padding(.bottom, 15)
                            .frame(height: 30)
                        
                    }
                    Button(action: {
                        
                        if !$viewModel.name.isNotEmpty.wrappedValue || !$viewModel.email.isNotEmpty.wrappedValue
                           || !$viewModel.password.isNotEmpty.wrappedValue || !$viewModel.verifiedPassword.isNotEmpty.wrappedValue {
                            if !$viewModel.name.isNotEmpty.wrappedValue {
                                showNameAlert = true
                                
                            }else{
                                showNameAlert = false
                            }

                            if !$viewModel.email.isNotEmpty.wrappedValue {
                                showEmailAlert = true
                            }
                            else{
                                showEmailAlert = false
                            }
                            if !$viewModel.password.isNotEmpty.wrappedValue {
                                print("nil val")
                                showPassAlert = true
                                
                            }
                            else{
                                showPassAlert = false
                            }
                            if !$viewModel.verifiedPassword.isNotEmpty.wrappedValue {
                                print("nil val")
                                showSecPassAlert = true
                                
                            }
                            else{
                                showSecPassAlert = false
                            }
                            return
                        }
                        viewModel.register()
                        
                    }, label: {
                        Text("Sign Up")
                            .bold()
                            .frame(width: 200, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(hex: 0x5F879D, alpha: 1))
                            )
                            .foregroundColor(Color(hex: 0xF3EEE2))
                    })
                    .alert(isPresented: $viewModel.showAlertBox) {
                        if viewModel.showEmailDomainAlert {
                            return Alert(title: Text("Email Domain"), message: Text("WashU email only"), dismissButton: .default(Text("OK")))
                        } else if viewModel.showPasswordFail {
                            return Alert(title: Text("Error"), message: Text("Passwords do not match"), dismissButton: .default(Text("OK")))
                        } else {
                            return Alert(title: Text("Error"), message: Text("You might have an account already."), dismissButton: .default(Text("OK")))
                        }
                        
                        // left this for future email implementation.
//                        else {
//                            return Alert(title: Text("Sign-up successful"), message: Text("A verification email has been sent to your email address. Please verify your email to continue."), dismissButton: .default(Text("OK")))
//                        }
                    }
                    .padding(.top)
                    .offset(y: 20)
                    
                    
                }
  
                
                .frame(width: 300)
                Spacer()
            }.ignoresSafeArea()
        }.background( Color(hex: 0xF3EEE2, alpha: 1))
        
    }
    
    
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
