////
////  BookmarkViewModel.swift
////  BookmarkList
////
////  Created by jc.kim on 3/12/21.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//class BookmarkViewModel {
//
////    let bookmarkObservable : BehaviorRelay<[Bookmark]> = BehaviorRelay(value: [])
//    let bookmarkObservable : PublishSubject<[Bookmark]> = PublishSubject()
//    
//
//    var disposeBag = DisposeBag()
//
//    var bookmarkList = DataManager.shared.fetchPerson(sort: .rate)
//
//    init() {
//
//
//
////        Observable.just(Sort.rate)
////            .map(DataManager.shared.fetchPerson)
////            .map(fetchAll)
////            .debug()
////            .observe(on: MainScheduler.instance)
////            .bind(to: bookmarkObservable)
////            .disposed(by: disposeBag)
//
//
//
//    }
//
//    private func fetchAll(_ entity:[BookmarkEntity]) -> [Bookmark]{
//        return entity.map { target in
//            return Bookmark(id:Int(target.id) ,
//                            name: target.name ?? "",
//                            thumbnail: target.thumbnail ?? "",
//                            imagePath: target.imagePath ?? "",
//                            subject: target.subject ?? "",
//                            price: Int(target.price),
//                            rate: target.rate,
//                            rateTime: target.rateTime)
//        }
//    }
//
//}
