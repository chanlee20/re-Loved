//
//  ChatLogView.swift
//  reLoved
//
//  Created by 이찬 on 3/2/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import PhotosUI

struct ChatLogView: View {
    @State var chatText = ""
    @State var itemUID:String?
    @State var postUserUID:String?
    @StateObject var imagePicker = ImagePicker()
    @State var selectedItems = [PhotosPickerItem]()
    @State var selectedImages = [UIImage]()
    @State private var showAlert = false
    @State private var showAlertTwo = false
    @State private var showReviewView = false
    @State private var showBlockAlert = false
    @StateObject var blockViewModel = BlockViewModel()
    @State private var postImage : UIImage?
    
    @ObservedObject var vm : ChatLogViewModel
    init(postUserUID:String, itemUID:String) {
        self.itemUID = itemUID
        self.postUserUID = postUserUID
        self.vm = ChatLogViewModel(postUserUID: postUserUID, itemUID: itemUID)
        
    }
    var body: some View {
        messagesView
            .navigationTitle(vm.otherUserName)
            .navigationBarTitleDisplayMode(.inline)
        
    }
    
    private var bottomBar: some View {
        
        HStack(spacing: 16){
            TextField("Description", text: $chatText)
            ZStack{
                if selectedImages.count > 0{
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(selectedImages, id: \.self){
                                img in Image(uiImage: img).resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                    }
                }
                PhotosPicker( selection: $selectedItems, matching: .any(of:[.images, .not(.videos)])){
                    Image(systemName: "photo")
                }.tint(.gray)
                    .controlSize(.small)
                    .buttonStyle(.borderedProminent)
                    .onChange(of: selectedItems) { newValues in
                        Task{
                            selectedImages = []
                            for value in newValues {
                                if let imageData = try? await value.loadTransferable(type: Data.self), let image = UIImage(data: imageData){
                                    selectedImages.append(image)
                                    
                                }
                            }
                        }
                    }
            }
            Button {
                vm.handleSend(text: self.chatText, toId: postUserUID ?? "", itemUID: itemUID ?? "", selectedImages: selectedImages )
                self.chatText = ""
                
                selectedImages = []
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var messagesView: some View {
        VStack{
            ZStack(alignment: .leading) {
                // create a semi-transparent rectangle that covers the entire screen
                Rectangle()
                    .foregroundColor(Color.white)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack{
                        
                        if vm.postImage != nil {
                            // we check that the vm.postImage is not null above
                            Image(uiImage: vm.postImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50).clipped().padding(.init(top: 15, leading: 15, bottom: 0, trailing: 0))
                            
                        } else  {
                            // Show loading spinner only if the image hasn't been fetched yet
                            ProgressView()
                        }
                        VStack(alignment: .leading) {
                            HStack(alignment: .center){
                                Text(vm.postName).font(.system(size:17))
                            }
                            Text("$"+vm.price).bold().font(.system(size:14))
                        }
                        Spacer()
                    }
                    HStack {
                        if vm.currentUserUID == vm.userUID{
                            NavigationLink(
                                destination: EachReviewView(opponentUserUID: self.postUserUID ?? "", itemUID: self.itemUID ?? ""),
                                label: {
                                    HStack{
                                        Image(systemName: "highlighter").foregroundColor(Color(hex: "#5F879D"))
                                        Text("Read Your Review")
                                            .foregroundColor(.black)
                                            .font(.system(size:14))
                                    }
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color(hex: "#5F879D"), lineWidth: 1)
                                    )
                                }
                            )
                            
                        }
                        else{
                            
                            if vm.hasReviewed{
                                Button(action: {
                                    showAlertTwo = true
                                }) {
                                    HStack{
                                        Image(systemName: "highlighter").foregroundColor(Color(hex: "#5F879D"))
                                        Text("Leave a Review")
                                            .foregroundColor(.black)
                                            .font(.system(size:14))
                                    }.padding(8)
                                        .background(Color.white)
                                        .cornerRadius(4)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(Color(hex: "#5F879D"), lineWidth: 1)
                                        )
                                }
                                .alert(isPresented: $showAlertTwo) {
                                    Alert(
                                        title: Text("You already left a review for this user"),
                                        primaryButton: .cancel(), secondaryButton: .default(Text("Yes"), action: {
                                            showReviewView = false
                                        })
                                    )
                                }
                            }
                            else{
                                Button(action: {
                                    showAlert = true
                                }) {
                                    HStack{
                                        Image(systemName: "highlighter").foregroundColor(Color(hex: "#5F879D"))
                                        Text("Leave a Review")
                                            .foregroundColor(.black)
                                            .font(.system(size:14))
                                    }.padding(7)
                                        .background(Color.white)
                                        .cornerRadius(4)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(Color(hex: "#5F879D"), lineWidth: 1)
                                        )
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Did you finish your transaction with \(vm.otherUserName)?"),
                                        primaryButton: .cancel(),
                                        secondaryButton: .default(Text("Yes"), action: {
                                            showReviewView = true
                                        })
                                    )
                                }
                                NavigationLink(
                                    destination: ReviewView(opponentUserUID: self.postUserUID ?? "", itemUID: self.itemUID ?? ""),
                                    isActive: $showReviewView,
                                    label: { EmptyView() }
                                )
                            }
                            
                            
                        }
                        Button("Block User", action: {showBlockAlert = true})
                            .alert(isPresented: $showBlockAlert) {
                                Alert(
                                    title: Text("If you block this user, you will not be able to see any of the user's content. Would you like to proceed?"),
                                    primaryButton: .cancel(), secondaryButton: .default(Text("Yes"), action: {blockViewModel.blockThisUser(blockedUserUID: vm.postUserUID)})
                                )
                            }
                            .padding(10)
                        
                        
                        
                        
                        
                        Spacer()
                    }.padding(.init(top: 0, leading: 15, bottom: 0, trailing: 0))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 110)
            ScrollView {
                ScrollViewReader{
                    scrollViewProxy in
                    VStack {
                        ForEach(vm.chatMessages) {
                            message in
                            if(message.fromId == Firebase.Auth.auth().currentUser?.uid) {
                                HStack{
                                    Spacer()
                                    VStack{
                                        if !message.images.isEmpty {
                                            if let image = message.image {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                        }
                                        Text(message.text)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(Color(hex: "#5F879D"))
                                    .cornerRadius(8)
                                }.padding(.horizontal)
                                    .padding(.top, 8)
                            }
                            else{
                                HStack{
                                    VStack{
                                        if !message.images.isEmpty {
                                            if let image = message.image {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                        }
                                        Text(message.text)
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    Spacer()
                                }.padding(.horizontal)
                                    .padding(.top, 8)
                            }
                            
                        }
                        HStack{
                            Spacer()
                        }
                        Spacer()
                            .frame(height: 20)
                            .id("Empty")
                    }
                    //.id("Empty")
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)){
                            scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.init(white:0.95, alpha: 1)))
            .safeAreaInset(edge: .bottom){
                bottomBar
                    .background(Color(.systemBackground).ignoresSafeArea())
            }
        }

    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ChatLogView(postUserUID: "", itemUID: "")
        }
    }
}




