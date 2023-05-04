//
//  FilterBadge.swift
//  reLoved
//
//  Created by 이찬 on 4/8/23.
//

import SwiftUI

struct FilterBadge: View {
    var text: String
    var backgroundColor: Color
    var textColor: Color
    var body: some View {
        Menu {
            Button("On Sale") {
                // Handle "On Sale" option
            }
            Button("Sold") {
                // Handle "Sold" option
            }
        } label: {
            ZStack {
                backgroundColor
                    .frame(width: 80, height: 35)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                HStack{
                    Text(text)
                        .foregroundColor(textColor)
                        .font(.caption.bold())
                    Image(systemName: "chevron.down").foregroundColor(textColor).imageScale(.small)
                }
                
            }
        }
    }
}

