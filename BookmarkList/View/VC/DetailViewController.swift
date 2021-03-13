//
//  DetailViewController.swift
//  BookmarkList
//
//  Created by jc.kim on 3/12/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var target: Bookmark?
    
    @IBAction func bookmarkButtonDidTap(_ sender: UIButton) {
        guard let item = self.target else { return }

        if !sender.isSelected {
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
        sender.isSelected = !sender.isSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        guard let target = self.target else { return }
        detailImageView.load(url: URL(string:target.imagePath) ?? URL.init(fileURLWithPath: ""))
        nameLabel.text = target.name
        subjectLabel.text = target.subject
        rateLabel.text = "⭐️\(target.rate ?? 0.0)"
        priceLabel.text = target.price.currencyKR()
        bookmarkButton.isSelected =
            DataManager.shared.items.map{$0.id}.contains(target.id) ? true : false
        
        
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(popAction))
        leftBarButton.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButton
    }

    
    @objc func popAction() {
        self.navigationController?.popViewController(animated: true)
    }


}
