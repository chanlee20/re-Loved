//
//  reLovedApp.swift
//  reLoved
//
//  Created by 이찬 on 2/5/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore


@main
struct reLovedApp: App {
    

    init() {FirebaseApp.configure()}

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            LoginView()
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       
        return true
    }
}
