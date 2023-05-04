//
//  EachReviewView.swift
//  reLoved
//
//  Created by 이찬 on 3/29/23.
//

import SwiftUI

struct EachReviewView: View {
    @State var opponentUserUID:String?
    
    @ObservedObject var vm : EachReviewViewModel
    
    init(opponentUserUID: String?, itemUID: String?) {
        self.vm = EachReviewViewModel(opponentUserUID: opponentUserUID ?? "", itemUID: itemUID ?? "")
    }
    
    var body: some View {
        if vm.review != "" {
            VStack(alignment: .leading){
                Text("Rating: ")
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= vm.rating ? "heart.fill" : "heart")
                            .foregroundColor(Color(hex: "#5F879D"))
                            .font(.system(size: 24))
                    }
                }
                Text("Review: ")
                Text(vm.review)
            }.padding(.horizontal)
        } else{
            Text("No Review Written Yet")
        }
    }
}

struct EachReviewView_Previews: PreviewProvider {
    static var previews: some View {
        EachReviewView(opponentUserUID: "", itemUID: "")
    }
}
