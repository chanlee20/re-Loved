//
//  SearchHistoryView.swift
//  reLoved
//
//  Created by Chae Hun Lim on 3/31/23.
//

import SwiftUI
import Collections
struct SearchHistoryView: View {
    
    
    @StateObject var searchHistoryViewModel = SearchHistoryViewModel()
    var recentSearches = SearchHistoryViewModel().recentSearches

    var body: some View {
        
        ScrollView{
            VStack{
                VStack{
                    VStack(alignment: .leading){
                        ForEach(searchHistoryViewModel.recentSearches.indices,id: \.self){
                            i in
                            NavigationLink(searchHistoryViewModel.recentSearches[i][1], destination: PostView(itemUID: searchHistoryViewModel.recentSearches[i][0], postUserUID:searchHistoryViewModel.recentSearches[i][2]))
                            
                            
                        }
                        
                        
                    }
                }
            }.padding(.leading,20)
                .padding(.trailing,20)
            
        }.onAppear{
            
        }
        
    }
}

struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView()
    }
}
