//
//  MainView.swift
//  reLoved
//
//  Created by 이찬 on 2/10/23.
//
import SwiftUI
import Firebase
struct MainView: View {
    @State var loggedout = false
    @StateObject var postViewModel = PostViewModel()
    @StateObject var loginViewModel = LoginViewModel()
    var body: some View{
        //if logout go to login page
        if loginViewModel.isUserLoggedIn {
            LoginView()
        }
        else{
            content
        }
    }
    
    var content: some View {
        
        VStack{
            TabView {
                HomeView().tabItem{
                    Image(systemName: "house.circle.fill")
                }
                ChatView().tabItem{
                    Image(systemName: "message.circle.fill")
                }
                LikedView().tabItem{
                    Image(systemName: "heart.circle")
                }
                ProfileView().tabItem{
                    Image(systemName: "person.crop.circle")
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                // correct the transparency bug for Tab bars
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithOpaqueBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                // correct the transparency bug for Navigation bars
                let navigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.configureWithOpaqueBackground()
                UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            }
        }
        
        
    }
    
    //logout
    func logout() {
        do{
            try Auth.auth().signOut()
            loggedout = true
        }
        catch{
            loggedout = false
            print("failed to logout")
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
