//
//  chatView.swift
//  reLoved
//
//  Created by Jiwoo Seo on 2/10/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ChatView: View {
    @ObservedObject var vm = ChatViewModel()
    @State var count = 0
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                HStack(spacing: 16){
                    if vm.profileImage != nil {
                        vm.profileImage!.resizable().frame(width: 65.0, height: 65.0).cornerRadius(100)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 65.0, height: 65.0).cornerRadius(100)
                    }
                    VStack(alignment: .leading, spacing: 4){
                        Text(vm.currentUserName).font(.system(size: 24, weight: .bold))
                    }
                    Spacer()
                }.padding()
                
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(vm.recentMessages, id: \.id) { recentMessage in
                            NavigationLink(destination: ChatLogView(postUserUID: recentMessage.toId, itemUID: recentMessage.itemUID)) {
                                ChatCellView(recentMessage: recentMessage)
                                    .padding(.leading, 16)
                            }.padding(7)
                            Divider()
                                .buttonStyle(PlainButtonStyle())
                                .foregroundColor(.primary)
                        }
                        
                    }
                }
            }.padding(.vertical, 8)
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                vm.fetchCurrentUser()
                UserViewModel().fetchBlockList() { (result) in
                    
                    switch result {
                    case .success(let result):
                        
                        vm.fetchUserMessages(blockList: result)
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    }
                    
                    
                }
                
//                vm.fetchOpponentUserName(toId: "")
//                vm.fetchOpponentProfilePic(profile_uid: "profile/default.jpg")
            }
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
