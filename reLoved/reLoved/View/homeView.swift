//
//  homeView.swift
//  reLoved
//
//  Created by Jiwoo Seo on 2/10/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct HomeView: View {
    init() {}
    @State private var image = UIImage()
    @State private var showSheet = false
    @StateObject var postViewModel = PostViewModel()
    @StateObject var userViewModel = UserViewModel()
    @State var showAddPostView: Bool = false
    @State private var searchText = ""
    @State private var searchCategory = "all"
    @State var searchBarInView = true
    @State var isAddPostView = false
    @State var showSearchBar = false
    var filteredPosts: [PostModel] {
        if searchText.isEmpty && searchCategory == (SearchCategories.all).rawValue {
            print("search: " + searchText)
            print(postViewModel.posts)
            return postViewModel.posts
        } else if searchText.isEmpty && searchCategory != (SearchCategories.all).rawValue {
            return postViewModel.posts.filter {
                $0.category?.contains(searchCategory) ?? false
            }
        } else if !searchText.isEmpty && searchCategory == (SearchCategories.all).rawValue {
            return postViewModel.posts.filter {
                $0.name?.contains(searchText) ?? false }
        } else {
            return postViewModel.posts.filter {
                $0.category?.contains(searchCategory) ?? false && $0.name?.contains(searchText) ?? false
            }
        }
    }
    
    
    var body: some View {
        NavigationStack{
            HStack{
                Spacer()
                if !showSearchBar {
                    Image(systemName: "magnifyingglass")
                        .padding(.horizontal, 10)
                        .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                        .onTapGesture {
                            withAnimation {
                                showSearchBar = true
                            }
                        }
                        .offset(x:0)
                        .opacity(1)
                }
                else{
                    SearchBar(text: $searchText).foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                        .onDisappear{
                            if !isAddPostView{
                                searchBarInView = false
                            }
                        }.onAppear{
                            searchBarInView = true
                        }
                        .transition(.move(edge: .trailing))
                }
                                Menu {
                                    NavigationLink(destination: SearchHistoryView()){
                                        Label("Search History", systemImage: "clock")
                                    }

                                } label: {
                                    Image(systemName: "list.dash")
                                        .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                                }
                
            }.padding(.leading,20)
                .padding(.trailing,20)
                .frame(height: 50)
            
            Picker("Category", selection: $searchCategory) {
                ForEach(SearchCategories.allCases) { category in
                    Text(category.rawValue.capitalized)
                        .tag(category.rawValue)
                }
            }.onChange(of: searchCategory, perform: { (value) in
                print(searchCategory)
            })
            .pickerStyle(.segmented)
            
            
            ScrollView{
                
                VStack(spacing: 0){
                    ForEach(filteredPosts){
                        post in
                        CardContainerView(post: post)
                    }.padding(.vertical, 20)
                }
                .padding(20)
                
                
            }
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if searchBarInView{
                            NavigationLink(destination: AddPostView(), isActive: $isAddPostView) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(22)
                                    .background(Color(hex: 0x5F879D, alpha: 1))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.trailing, 32)
                    .padding(.bottom, 16)
                }
            )
        }.onAppear{
            showSearchBar = false;
            userViewModel.fetchBlockList() { (result) in
                switch result {
                case .success(let result):
                    
                    postViewModel.fetch(blockedList: result)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        }
        
    }
}






struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
