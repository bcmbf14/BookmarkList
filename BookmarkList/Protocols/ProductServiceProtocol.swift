//
//  ProductServiceProtocol.swift
//  BookmarkList
//
//  Created by jc.kim on 3/11/21.
//

import Alamofire

protocol ImageServiceProtocol {
    @discardableResult
    func search(page: Int, completionHandler: @escaping (AFResult<ListResult?>) -> Void) -> DataRequest
}
