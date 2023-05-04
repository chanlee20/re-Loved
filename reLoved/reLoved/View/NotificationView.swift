//
//  NotificationView.swift
//  reLoved
//
//  Created by 이찬 on 4/8/23.
//

import SwiftUI

struct NotificationView: View {
    @ObservedObject var vm = NotificationViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(vm.notifications) { notification in
                        // Display the notification here...
                        NavigationLink(destination: PostView(itemUID: notification.postID, postUserUID: notification.postUser)){
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "bell.circle")
                                    .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(notification.content ?? "Notification")
                                        .font(.headline)
                                        .foregroundColor(Color(hex: 0x5F879D, alpha: 1))
                                    
                                    Text("Click to see the update")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(notification.timeago)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                        
                    }
                    
                }
                .navigationTitle("Notifications")
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
                .padding(.top, 20)
                
            }
        }
    }
}

