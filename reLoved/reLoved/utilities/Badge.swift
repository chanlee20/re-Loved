//
//  Badge.swift
//  reLoved
//
//  Created by 이찬 on 4/8/23.
//

import SwiftUI

struct Badge: View {
    var text: String
    var backgroundColor: Color
    var textColor: Color
    
    var body: some View {
        ZStack {
            backgroundColor
                .frame(width: 80, height: 35)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            Text(text)
                .foregroundColor(textColor)
                .font(.caption)
                .fontWeight(.bold)
        }
    }
}

