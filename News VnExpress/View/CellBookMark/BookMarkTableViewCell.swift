//
//  NewsTableViewCell.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import UIKit
//import SwipeCellKit

class BookMarkTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var contentNews: UILabel!
    @IBOutlet weak var pubDateNews: UILabel!
    @IBOutlet weak var shareNews: UIButton!
    
    @IBOutlet weak var imageNews: CustomImageView!
    
    weak var bookmarkViewController: BookMarkViewController?
    
    var item: BookmarkModel? {
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
        shareNews.addTarget(self, action: #selector(didTapShare(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Functions
    
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
            bookmarkViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    // refesh Update UI
    private func refesh() {
        DispatchQueue.main.async { [weak self] in
            self?.titleNews.text = self?.item?.title
            self?.contentNews.text = self?.item?.descriptionString
            self?.pubDateNews.text = self?.item?.pubDate
            self?.imageNews.loadImageUrlString(urlString: self?.item?.imgSrc ?? "")
        }
    }
    
}
