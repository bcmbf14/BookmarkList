//
//  BookmarkViewController.swift
//  BookmarkList
//
//  Created by jc.kim on 3/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var token: NSObjectProtocol?
    
    var bookmarkList = [BookmarkEntity]()
    
    var disposeBag = DisposeBag()
    
    
    @IBAction func sort(_ sender: Any) {
        showAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
        setupCoredata(.rate)
        
        token = NotificationCenter.default.addObserver(forName: .bookmarkButtonIsSelected, object: nil, queue: nil) { [weak self] _ in
            self?.bookmarkList = DataManager.shared.fetchBookmark()
            self?.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    private func configureUI() {
        tableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
    }
    
    private func setupCoredata(_ sort: Sort) {
        
        bookmarkList = DataManager.shared.fetchBookmark(sort: sort)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let identifier = segue.identifier ?? ""
        if identifier == "toDetailVC", let detailVC = segue.destination as? DetailViewController, let indexPath = sender as? IndexPath {
            
            let target = self.bookmarkList[indexPath.row]
            let bookmark = Bookmark(id:Int16(target.id), name: target.name ?? "", thumbnail: target.thumbnail ?? "", imagePath: target.imagePath ?? "", subject: target.subject ?? "", price: Int64(target.price), rate: target.rate, rateTime: target.rateTime)
            
            detailVC.target = bookmark
        }
    }
    
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
}

extension BookmarkViewController {
    
    func showAlert() {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.view.tintColor = .black
        
        let sortByRateAction = UIAlertAction(title: "평점순", style: .default) { [weak self] _ in
            self?.tableView.scrollToRow(at: [0,0], at: .top, animated: true)
            self?.setupCoredata(.rate)
        }
        
        let sortByTimeAction = UIAlertAction(title: "최신순", style: .default) { [weak self] _ in
            self?.tableView.scrollToRow(at: [0,0], at: .top, animated: true)
            self?.setupCoredata(.time)
        }
        
        alertVC.addAction(sortByRateAction)
        alertVC.addAction(sortByTimeAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}



extension BookmarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        self.performSegue(withIdentifier: "toDetailVC", sender: indexPath)
    }
}


extension BookmarkViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as! ListTableViewCell
        
        let target = bookmarkList[indexPath.row]
        
        let result = Bookmark(id:Int16(target.id) , name: target.name ?? "", thumbnail: target.thumbnail ?? "", imagePath: target.imagePath ?? "", subject: target.subject ?? "", price: Int64(target.price), rate: target.rate, rateTime: target.rateTime)
        
        cell.setData(result)
        cell.priceLabel.isHidden = true
        
        cell.bookmarkButtonDidTap = {
            let entity = self.bookmarkList.remove(at: indexPath.row)
            DataManager.shared.delete(entity: entity)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            Toaster.remove()
            
        }
        return cell
    }
}

