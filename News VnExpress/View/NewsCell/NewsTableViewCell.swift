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
    @IBOutlet weak var shareNews: UIButton!
    
    @IBOutlet weak var imageNews: CustomImageView!
    
    var bookmarkTapAction: ((Bool) -> Void)?
    
    var item: NewsModel? {
        didSet {
            refesh()
        }
    }
    
    let realmServirce = RealmServices()
    
    weak var mainViewController: MainViewController?
    
    //MARK: - Override Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        imageNews.contentMode = .scaleToFill
        imageNews.layer.cornerRadius = 10
        imageNews.layer.masksToBounds = true
        
        titleNews.textColor = UIColor(named: Contants.Color.titleColor)
        titleNews.contentMode = .scaleAspectFill
        
        bookMarkButton.addTarget(self, action: #selector(didTapBookmark(_:)), for: .touchUpInside)
        shareNews.addTarget(self, action: #selector(didTapShare(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Funtions
    
/*
     Logic when user click bookmark when user at main view controller now,                  (1)
     or user click bookmark at bookmark view controller then back to main view controller,  (2)
     or user click bookmark when get start appication                                       (3)
     
     All of the above cases are handled here - @objc func didTapBookmark(_:)
*/
    @objc func didTapBookmark(_ sender: UIButton) {
        
        guard let item = item else {
            return
        }
        
        // Convert from News Model to News Model Realm
        let newItemBookmark  = BookmarkModel.toBookmarkModel(fromModel: item)
       
        if sender.isSelected {
            
            let results = Contants.realm.objects(BookmarkModel.self).filter("title = %@", item.title)
            
            // User click bookmark normal   (1)
            if results.count != 0 {
                sender.isSelected = false
                bookmarkTapAction?(false)
                bookMarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                
                realmServirce.deleteData(deleteObj: results)
            } else {
                // User click bookmark at bookmark view controller then back to main view controller    (2)
                sender.isSelected = true
                bookmarkTapAction?(true)
                bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                
                realmServirce.saveData(saveObj: newItemBookmark)
            }
            
        // Bookmark is click the first time
        } else {
            
            let results = Contants.realm.objects(BookmarkModel.self).filter("title = %@", item.title)
            
            // User click bookmark when get start appication    (3)
            if results.count != 0 {
                sender.isSelected = false
                bookmarkTapAction?(false)
                bookMarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)

                realmServirce.deleteData(deleteObj: results)
            } else {
                // User click bookmark normal   (1)
                sender.isSelected = true
                bookmarkTapAction?(true)
                bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                
                // save or update bookmark to in database
                realmServirce.saveData(saveObj: newItemBookmark)
            }
            
        }
        
    }
    
    @objc func didTapShare(_ sender: UIButton) {
        guard let item = item else {
            return
        }
        
        let message = item.title
        // creating share sheet
        if let link = NSURL(string: item.link) {
            let objectsToShare = [message,link] as [Any]
            
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.message, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToFacebook]
            
            // present share sheet on an iPad
            activityViewController.popoverPresentationController?.sourceView = sender
            activityViewController.popoverPresentationController?.sourceRect = sender.frame
            mainViewController?.present(activityViewController, animated: true, completion: nil)
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
