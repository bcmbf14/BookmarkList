//
//  Data.swift
//  BookmarkList
//
//  Created by jc.kim on 3/11/21.
//

import Foundation

struct Response: Codable {
    let totalCount: Int
    let product: [Product]
}
