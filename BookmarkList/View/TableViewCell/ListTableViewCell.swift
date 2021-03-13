//
//  ListTableViewCell.swift
//  BookmarkList
//
//  Created by jc.kim on 3/11/21.
//

import UIKit
import RxSwift


class ListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ListTableViewCell"
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateTimeLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var bookmarkButtonDidTap: (()->())?
    
    let activityIndicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func prepareForReuse() {
        contentImageView.image = nil
        titleLabel.text = nil
        subjectLabel.text = nil
        rateLabel.text = nil
        rateTimeLabel.text = nil
        priceLabel.text = nil
    }
    
    @IBAction func bookmarkButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        bookmarkButtonDidTap?()
        
    }
    
    func setData(_ data: Bookmark) {
        loadImage(from: data.thumbnail)
            .asDriver(onErrorJustReturn: UIImage(systemName: "photo"))
            .drive(contentImageView.rx.image)
            .disposed(by: disposeBag)

        titleLabel.text = data.name
        subjectLabel.text = data.subject
        rateLabel.text = "⭐️\(data.rate ?? 0.0)"
        priceLabel.text = data.price.currencyKR()
        rateTimeLabel.text = data.rateTime?.toString()
        bookmarkButton.isSelected =
            DataManager.shared.items.map{$0.id}.contains(data.id) ? true : false
        subjectLabel.isHidden = data.subject == ""
    }
}


extension ListTableViewCell {
    private func loadImage(from urlStr: String) -> Observable<UIImage?> {
        self.startActivityIndicator()

        return Observable.create { emitter in
            guard let url = URL(string: urlStr) ?? nil else {
                print("Invalid URL")
                emitter.onNext(UIImage(systemName: "photo"))
                return Disposables.create()
            }
            
            let cacheKey = NSString(string: urlStr)

            if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                emitter.onNext(cachedImage)
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self ] data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                guard let data = data,
                      let image = UIImage(data: data) else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }
                
                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                self?.stopActivityIndicator()
                
                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}


extension ListTableViewCell {
    
    private func startActivityIndicator(){
        activityIndicator.style = .medium
        activityIndicator.color = .darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentImageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentImageView.centerYAnchor)
        ])
    }
    
    private func stopActivityIndicator(){
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.removeFromSuperview()
        }
    }
}
