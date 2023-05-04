//
//  signUpViewModel.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/22/23.
//

import Foundation
import Firebase
import FirebaseFirestore

final class SignUpViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var name = ""
    @Published var password = ""
    @Published var verifiedPassword = ""
    @Published var isUserSignedUp = false
    @Published var db = Firestore.firestore()
    @Published var showEmailDomainAlert = false
    @Published var showSignUpFailed = false
    @Published var showPasswordFail = false
    @Published var showEmailVerificationAlert = false
    @Published var showAlertBox = false
    /**
     Register user to firebase Authentication
     Add user Info to the Firebase DB
     :param
     :return:
     
     */
    func register() {
        
        if !email.contains("@wustl.edu") {
            print("invalid email domain")
            showEmailDomainAlert = true
            showAlertBox = true
            return
        }
        if verifiedPassword != password {
            print("wrong passwords")
            showPasswordFail = true
            showAlertBox = true
            return
        }
        
        showEmailDomainAlert = false
        showPasswordFail = false
        showAlertBox = false
        
        Auth.auth().createUser(withEmail: email, password: password){
            result, error in
            if error != nil{
                self.showSignUpFailed = true
                self.showAlertBox = true
                print(error?.localizedDescription ?? "error")
            } else {
                
                guard let userUID = result?.user.uid else {return}
                self.db.collection("users").document(userUID).setData([
                    "name": self.name,
                    "email": self.email,
                    "uid": userUID,
                    "likes": [String](),
                    "user-rating": 2.5,
                    "totalReviews": 1
                    
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        self.isUserSignedUp = true
                        self.showSignUpFailed = false
                        self.showAlertBox = false
                        print("Document successfully written!")
                    }
                }
                
                // email verification code worked for non-wustl email. Leaving the code here for future implementation.
                
//                result?.user.sendEmailVerification(completion: { error in
//                    if let error = error {
//                        print("Error sending verification email: \(error.localizedDescription)")
//                    } else {
//                        print("Verification email sent successfully.")
//                        self.showEmailVerificationAlert = true
//                        self.showAlertBox = true
//                    }
//                })
                
            }
            
            
            
        }
        
        
        
        
        
    }
    
    
    
}
