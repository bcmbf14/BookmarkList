//
//  ListViewController.swift
//  BookmarkList
//
//  Created by jc.kim on 3/10/21.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import CoreData

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var imageService : ImageService!
    
    let viewModel = TotalItemsViewModel()
    var disposeBag = DisposeBag()
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
        
        setupBindings()

        
        
        tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rx.modelSelected(Bookmark.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] bookmark in
                guard let detailVc = self?.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
                detailVc.target = bookmark
                self?.navigationController?.pushViewController(detailVc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        tableView.dataSource = nil
        tableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        tableView.bounces = false
    }
    
    private func setupBindings() {
        
        viewModel.totalItemsRelay
            .bind(to: tableView.rx.items(cellIdentifier: ListTableViewCell.reuseIdentifier, cellType: ListTableViewCell.self)) { index, item, cell in
                cell.setData(item)
                
                cell.bookmarkButtonDidTap = {
                    
                    if cell.bookmarkButton.isSelected {
                        DataManager.shared.createPerson(mark: item) {
                            
                            NotificationCenter.default.post(name:.bookmarkButtonIsSelected , object: nil)
                            Toaster.show()

                        }

                    }else {
                        if let entity = DataManager.shared.fetchBookmark().filter({$0.id == item.id}).first {
                            DataManager.shared.delete(entity: entity)
                            
                            
                            Toaster.remove()

                        }
                        
                    }
                }
            }
            .disposed(by: disposeBag)
    
        
        let itemsCount = viewModel.totalItemsRelay.map{$0.count-1}
        let prefetchItems = tableView.rx.prefetchRows
            .map{$0.last?.row ?? 0}
        
        Observable.combineLatest(itemsCount, prefetchItems)
            .asDriver(onErrorJustReturn: (0,0))
            .filter{ $0.0 > 0 }
            .filter{ $0 == $1 }
            .map{_ in
                if self.viewModel.page < 3 {
                    self.viewModel.page += 1
                }
                return self.viewModel.page
            }
            .drive(viewModel.pageRelay)
            .disposed(by: disposeBag)
        
            
        
    }
    
}




extension Notification.Name {
    static let bookmarkButtonIsSelected = Notification.Name("bookmarkButtonIsSelected")
}
