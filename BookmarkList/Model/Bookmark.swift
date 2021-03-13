//
//  Bookmark.swift
//  BookmarkList
//
//  Created by jc.kim on 3/12/21.
//

import Foundation

struct Bookmark {
    let id: Int16
    let name: String
    let thumbnail: String
    let imagePath: String
    let subject: String?
    let price: Int64
    let rate: Double?
    let rateTime: Date?
}
