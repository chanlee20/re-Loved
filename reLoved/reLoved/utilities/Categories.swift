//
//  Categories.swift
//  reLoved
//
//  Created by Jiwoo Seo on 4/26/23.
//

import Foundation
enum Categories: String, CaseIterable, Identifiable {
    case stuff, mealpoints, housing
    var id: Self { self }
}

