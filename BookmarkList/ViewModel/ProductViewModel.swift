//
//  ProductViewModel.swift
//  BookmarkList
//
//  Created by jc.kim on 3/11/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class TotalItemsViewModel {
    
    lazy var pageRelay : BehaviorRelay<Int> = BehaviorRelay(value: page)
    let totalItemsRelay: BehaviorRelay<[Bookmark]> = BehaviorRelay(value: [])
    var disposeBag = DisposeBag()
    
    
    var totalItems = [Bookmark]()
    var page = 1

    
    let imageService = ImageService(sessionManager: Session.default)
    
    init() {
        pageRelay
            .filter{$0<4}
            .distinctUntilChanged()
            .flatMap(imageService.searchRx)
            .map(appendItems)
            .asDriver(onErrorJustReturn: [])
            .drive(totalItemsRelay)
            .disposed(by: disposeBag)
    }
        
    private func appendItems(_ items: [Bookmark]) -> [Bookmark]{
        self.totalItems.append(contentsOf: items)
        return totalItems
    }
}
