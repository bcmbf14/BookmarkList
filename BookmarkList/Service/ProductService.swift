//
//  ProductService.swift
//  BookmarkList
//
//  Created by jc.kim on 3/11/21.
//

import Foundation
import RxSwift
import Alamofire


final class ImageService: ImageServiceProtocol {
    
    private let sessionManager: SessionManagerProtocol
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    func searchRx(_ page: Int = 1) -> Observable<[Bookmark]> {
        return Observable.create { emitter in
            _ = self.search(page: page) { (result) in
                switch result {
                case .success(let imageSearchResult):
                    if let imgs = imageSearchResult {
                        let result = imgs.data.product.map {
                            return Bookmark(id: Int16($0.id),
                                            name: $0.name,
                                            thumbnail: $0.thumbnail,
                                            imagePath: $0.productDescription.imagePath,
                                            subject: $0.productDescription.subject,
                                            price: Int64($0.productDescription.price),
                                            rate: $0.rate,
                                            rateTime: nil)
                        }
                        emitter.onNext(result)
                        emitter.onCompleted()
                    }
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
    func search(page: Int = 1, completionHandler: @escaping (AFResult<ListResult?>) -> Void) -> DataRequest {

        let URL = "https://www.gccompany.co.kr/App/json/\(page).json"
        
        return self.sessionManager.request(URL, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil, interceptor: nil, requestModifier: nil)
            .responseData { response in
                
                let result = response.result.map { (data) in
                     try? JSONDecoder().decode(ListResult.self, from: data)
                }
                
                completionHandler(result)
            }
    }
    
}
