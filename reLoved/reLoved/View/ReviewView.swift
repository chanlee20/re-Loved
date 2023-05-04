//
//  ReviewView.swift
//  reLoved
//
//  Created by 이찬 on 3/29/23.
//

import SwiftUI

struct ReviewView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var rating: Int = 0
    @State private var reviewText: String = ""
    @State var itemUID:String?
    @State var opponentUserUID:String?
    
    @ObservedObject var vm : ReviewViewModel
    init(opponentUserUID: String?, itemUID: String?) {
        self.vm = ReviewViewModel(opponentUserUID: opponentUserUID ?? "", itemUID: itemUID ?? "")
    }
    var body: some View {
        VStack(alignment: .center) {
            VStack{
                Text("Hello " + vm.currentUser + "!").bold().font(.system(size:24))
                Text("How was your overall experience with " + vm.opponentUser + "?")
            }.padding(5)
            
            VStack(alignment: .center){
                HStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { index in
                        Button(action: {
                            rating = index
                        }) {
                            Image(systemName: rating >= index ? "heart.fill" : "heart")
                                .foregroundColor(Color(hex: "#5F879D"))
                                .font(.system(size: 24))
                        }
                    }
                }
            }
            Spacer()
            VStack {
                Text("Tell us more about your experience!")
                TextField("Write here! (optional)", text: $reviewText, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(5, reservesSpace: true)
                    .textFieldStyle(.roundedBorder)
                Button {
                    vm.writeReview(review: reviewText, rating: rating)
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Submit")
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(hex: "#5F879D"))
                .cornerRadius(8)
                Spacer()
            }.padding(10)
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(opponentUserUID: "", itemUID: "")
    }
}
