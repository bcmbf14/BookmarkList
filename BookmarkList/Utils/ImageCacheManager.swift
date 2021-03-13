//
//  ImageCacheManager.swift
//  BookmarkList
//
//  Created by jc.kim on 3/12/21.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
