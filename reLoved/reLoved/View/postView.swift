//
//  postView.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/12/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore



struct PostView: View {
    //var post:PostModel
    @State var itemUID:String?
    @State var postUser:String?
    @State var postUserUID:String?
    @StateObject var searchHistoryViewModel = SearchHistoryViewModel()
    @StateObject var postViewModel = EachPostViewModel()
    @State var selectionIndex: Int = 0
    @Environment(\.presentationMode) var presentationMode
    @State private var isReportModalShown = false
    @State private var isModalPresented = false
    @State private var isLoading = true // add this state variable to track the loading status
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    var body: some View {
        NavigationView{
            ZStack() {
                GeometryReader { geometry in
                    ScrollView{
                        VStack() {
                            VStack(alignment: .leading) {
                                if postViewModel.isLoading { // show progress bar while loading
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: 0x5F879D, alpha: 1)))
                                            .frame(width: 300, height:200)
                                            .padding(.vertical, 20)
                                            .padding(.horizontal, 10)
                                        Spacer()
                                    }
                                    
                                } else { // show image once it's loaded
                                    Image(uiImage: postViewModel.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 300)
                                }
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            if postViewModel.profileImage != nil {
                                                postViewModel.profileImage!.resizable().frame(width: 30.0, height: 30.0).cornerRadius(100)
                                            } else {
                                                Image(systemName: "person.fill")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding(10)
                                                    .background(Color.gray)
                                                .clipShape(Circle())                    }
                                            
                                            Text(postViewModel.username)
                                                .font(.headline)
                                            
                                        }
                                        Text("Location: " + postViewModel.location)
                                        Text("Category: " + postViewModel.category)
                                    }
                                    Spacer()
                                    VStack{
                                        HStack{
                                            Image(systemName: "star.fill")
                                                .renderingMode(.template)
                                                .foregroundColor(Color(hex: "5F879D"))
                                            Text(String(postViewModel.userRating))
                                        }
                                        .padding(.bottom, 10)
                                        if(postViewModel.currentUserUID == postViewModel.userUID){
                                            Menu {
                                                Button("On Sale") {
                                                    // Handle "On Sale" option
                                                    postViewModel.post_status = "On Sale"
                                                    postViewModel.updateStatus(status: "On Sale", itemUID: itemUID ?? "")
                                                }
                                                Button("Sold") {
                                                    // Handle "Sold" option
                                                    postViewModel.post_status = "Sold"
                                                    postViewModel.updateStatus(status: "Sold", itemUID: itemUID ?? "")
                                                    
                                                }
                                            } label: {
                                                ZStack {
                                                    Color(hex: 0x5F879D, alpha: 1)
                                                        .frame(width: 80, height: 35)
                                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                                    HStack{
                                                        Text(postViewModel.post_status)
                                                            .foregroundColor(Color.white)
                                                            .font(.caption.bold())
                                                        Image(systemName: "chevron.down").foregroundColor(Color.white).imageScale(.small)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        else{
                                            Badge(text: postViewModel.post_status, backgroundColor: Color(hex: 0x5F879D, alpha: 1), textColor: .white)
                                                .padding(.leading, 10)
                                        }
                                    }
                                }.padding(20)
                                
                                Divider().padding(.horizontal, 20)
                                VStack{
                                    HStack {
                                        Text(postViewModel.name)
                                            .font(.title2)
                                            .fontWeight(.heavy)
                                        Spacer()
                                    }
                                    .padding(.top, 15)
                                    HStack {
                                        Text(postViewModel.description)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }.padding(.top, 5) .padding(.bottom, 50)
                                    
                                    
                                    
                                    
                                }.padding(.horizontal, 20)
                            }
                        }
                        
                    }.task{
                        
                        postViewModel.fetch(itemUID:itemUID ?? "")
                        
                        postViewModel.fetchByID(itemUID:itemUID ?? "") { (result) in
                            
                            switch result {
                            case .success(let result):
                                searchHistoryViewModel.addPostToRecentSearches(itemName: result[0], itemUID: itemUID ?? "", userUID: ProfileViewModel().userUID, postUserUID: result[1])
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                                
                            }
                            
                            
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                            }
                            .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                        }
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            if postViewModel.currentUserUID == postViewModel.userUID {
                                Menu {
                                    
                                    Button(action: {
                                        postViewModel.pullUpPost(itemUID: itemUID ?? "")
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Label("Pull Up", systemImage: "arrow.up.heart")
                                    }
                                    
                                    
                                    NavigationLink(destination: EditPostView(postViewModel: postViewModel)) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    
                                    
                                    Button(action: {
                                        postViewModel.deletePost(itemUID: itemUID ?? "")
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    
                                } label: {
                                    Image(systemName: "ellipsis").foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                                }
                                
                                
                            }
                            else{
                                Menu {
                                    NavigationLink(destination: ReportModalView(itemUID: itemUID, postUserUID: postUserUID)) {
                                        Label("Report this content", systemImage: "exclamationmark.bubble")
                                    }
                                }
                            label: {
                                Image(systemName: "ellipsis").foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                            }
                            }
                        }
                    }.frame(height: geometry.size.height)
                }
            }.toolbar(.hidden, for: .tabBar)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .overlay(
            VStack{
                Spacer()
                VStack{
                    Divider().padding(.bottom, 10)
                    HStack{
                        Button(action: {
                            postViewModel.addCurrentPostToUserLikesArray(itemUID: itemUID ?? "", clickedLike: !postViewModel.isLiked )
                            postViewModel.isPostLikedByCurrentUser(itemUID: itemUID ?? "") { success in
                                if success {
                                    print("liked: true")
                                    postViewModel.isLiked = true
                                }
                                else  {
                                    print("liked: false")
                                    postViewModel.isLiked = false
                                }
                            }
                        }) {
                            if postViewModel.isLiked{
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                                    .padding()
                            }
                            else {
                                Image(systemName: "heart")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                                    .padding()
                            }
                            
                        }
                        Divider()
                        Text("$" + postViewModel.price).bold()
                        Spacer()
                        if(postViewModel.userUID == postViewModel.currentUserUID){
                            // not show anything
                        }
                        else{
                            NavigationLink(destination: ChatLogView(postUserUID: postUserUID ?? "",  itemUID: itemUID ?? "")) {
                                
                                Text("Start Chatting")
                                    .bold()
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(15)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(hex: 0x5F879D, alpha: 1))
                                    )
                            }
                        }
                        
                    }.padding(.horizontal, 20).frame(height: 30).padding(.bottom, 15)
                    
                    
                }.background(Color(.white))
                
            }
                .navigationBarTitle(Text(""))
        ).gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                self.mode.wrappedValue.dismiss()
            }
            
        }))
        
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
