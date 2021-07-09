//
//  NewsTableViewCell.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import UIKit
import RealmSwift

class NewsTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var contentNews: UILabel!
    @IBOutlet weak var pubDateNews: UILabel!
    @IBOutlet weak var bookMarkButton: UIButton!
    
    @IBOutlet weak var imageNews: CustomImageView!
    
    weak var bookMarkViewController: BookMarkViewController?
    
    var bookmarkTapAction: ((Bool) -> Void)?
    
    var item: NewsModel? {
        didSet {
            refesh()
        }
    }
    
    //MARK: - Override Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        imageNews.contentMode = .scaleToFill
        imageNews.layer.cornerRadius = 10
        imageNews.layer.masksToBounds = true
        
        titleNews.textColor = UIColor(named: Contants.Color.titleColor)
        titleNews.contentMode = .scaleAspectFill
        
        bookMarkButton.addTarget(self, action: #selector(didTapBookmark(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        bookMarkButton.imageView?.image = UIImage(systemName: "bookmark")
//    }
    
    //MARK: - Funtions
    
    @objc func didTapBookmark(_ sender: UIButton) {
    
        let newItemBookmark  = BookmarkModel.toBookmarkModel(fromModel: item!)
        
        // bookmark diseleced
        if sender.isSelected {
            let results = Contants.realm.objects(BookmarkModel.self).filter("title = %@", newItemBookmark.title)
            
            sender.isSelected = false
            bookmarkTapAction?(false)
            
            bookMarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            // delete bookmark
            do {
                try Contants.realm.write {
                    Contants.realm.delete(results)
                    DispatchQueue.main.async { [weak self] in
                        self?.bookMarkViewController?.tableViewBookMark.reloadData()
                    }
                    print("deleted data")
                }
            }
            catch {
                print("error delete data: \(error.localizedDescription)")
            }
        
        // bookmark selected
        } else {
            sender.isSelected = true
            bookmarkTapAction?(true)
            
            bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)

            // save or update bookmark to in database
            try! Contants.realm.write {
                Contants.realm.add(newItemBookmark, update: .modified)
                DispatchQueue.main.async { [weak self] in
                    self?.bookMarkViewController?.tableViewBookMark.reloadData()
                }
                print("saved data")
            }
        }
        
    }
    
    // to refesh update UI
    private func refesh() {
        DispatchQueue.main.async { [weak self] in
            self?.titleNews.text = self?.item?.title
            self?.contentNews.text = self?.item?.descriptionString
            self?.pubDateNews.text = "\(self?.item?.datePubDate?.since ?? "")"
            self?.imageNews.loadImageUrlString(urlString: self?.item?.imgSrc ?? "")
        }
    }
    
}
