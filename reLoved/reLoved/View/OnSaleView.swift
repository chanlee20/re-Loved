//
//  OnSaleView.swift
//  reLoved
//
//  Created by Jiwoo Seo on 3/27/23.
//

import SwiftUI

struct OnSaleView: View {
    init() {}
    @State private var image = UIImage()
    @State private var showSheet = false
    @StateObject var onSaleViewModel = OnSaleViewModel()
    @State var showAddPostView: Bool = false
    
    
    
    var body: some View {
        
        
        ScrollView{
            VStack{
                VStack{
                    
                    VStack(alignment: .leading,spacing: 10){
                        ForEach(onSaleViewModel.posts){
                            post in
                            
                            CardContainerView(post: post)
                            
                        }.padding(.vertical, 20)
                    }
                }
            }.padding(20)
            
        }
        .onAppear{
            onSaleViewModel.fetchLikesListOfCurrentUser()
        }
        .navigationTitle("Your postings")
        
        
    }
}

struct OnSaleView_Previews: PreviewProvider {
    static var previews: some View {
        OnSaleView()
    }
}
