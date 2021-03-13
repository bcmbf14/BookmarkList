//
//  Product.swift
//  BookmarkList
//
//  Created by jc.kim on 3/11/21.
//

import Foundation


struct Product: Codable {
    let id: Int
    let name: String
    let thumbnail: String
    let productDescription: Description
    let rate: Double

    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail
        case productDescription = "description"
        case rate
    }
    
    struct Description: Codable {
        let imagePath: String
        let subject: String
        let price: Int
    }
}




