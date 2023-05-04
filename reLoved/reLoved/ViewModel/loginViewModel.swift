//
//  loginViewModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/22/23.
//

import Foundation
import Firebase
/**
 Basic Login Fuctionality
 */
final class LoginViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var isUserLoggedIn = false
    @Published var isUserNeedsVerification = false
    
    //login
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){ [self] result, error in
            if error != nil {
                print(error?.localizedDescription ?? "error in log in")
                self.isUserLoggedIn = false
            }
            else{
                
                self.isUserLoggedIn = true
            }
        }
        
    }
    //logout
    func logout() {
        do{
            try Auth.auth().signOut()
            print("user logged out")
            self.isUserLoggedIn = true
        }
        catch{
            self.isUserLoggedIn = false
            print("failed to logout")
        }
        
    }
    
    func checkUserLoggedIn(){
        
        Auth.auth().addStateDidChangeListener { auth, user in
            
            if user != nil {
                self.isUserLoggedIn = true;
            } else {
                self.isUserLoggedIn = false;
                
            }
            
        }
    }
    
    
}
