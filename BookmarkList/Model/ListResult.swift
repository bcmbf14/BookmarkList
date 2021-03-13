//
//  ListResult.swift
//  BookmarkList
//
//  Created by jc.kim on 3/11/21.
//

import Foundation

struct ListResult: Codable {
    let msg: String
    let data: Response
    let code: Int
}
