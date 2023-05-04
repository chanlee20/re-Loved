//
//  CardView.swift
//  reLoved
//
//  Created by Chae Hun Lim on 2/22/23.
//
import SwiftUI
import FirebaseStorage
/**
 Card Like View for posts
 */

struct CardView: View {
    var post: PostModel
    @StateObject var cardViewModel: CardViewModel
    
    init(post: PostModel) {
        self.post = post
        self._cardViewModel = StateObject(wrappedValue: CardViewModel(post: post))
    }
    
    var body: some View {
        NavigationLink(destination: PostView(itemUID: post.uid, postUserUID: post.user)) {
            GeometryReader { geo in
                VStack {
                    if cardViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: geo.size.width, height: 200)
                    } else {
                        VStack(alignment: .center)  {
                            Image(uiImage: cardViewModel.image ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, height: 200, alignment: .center)
                                .clipped()
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text(post.name ?? "")
                                .font(.body)
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text(post.category ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("$\(post.price ?? "")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                    }.padding()
                }
            }
        }
    }
}

struct CardContainerView: View {
    var post: PostModel
    
    var body: some View {
        CardView(post: post)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal, 8)
            .padding(.vertical, 0)
            .frame(height: 290) // set the fixed height of each card
    }
}
