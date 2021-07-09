//
//  NewsTableViewCell.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import UIKit
import SwipeCellKit

class BookMarkTableViewCell: SwipeTableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var contentNews: UILabel!
    @IBOutlet weak var pubDateNews: UILabel!
    
    @IBOutlet weak var imageNews: CustomImageView!
    
    weak var bookmarkVC: BookMarkViewController?
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Functions
    
    // refesh Update UI
    func refesh() {
        DispatchQueue.main.async { [weak self] in
            self?.titleNews.text = self?.item?.title
            self?.contentNews.text = self?.item?.descriptionString
            self?.pubDateNews.text = self?.item?.pubDate
            self?.imageNews.loadImageUrlString(urlString: self?.item?.imgSrc ?? "")
        }
    }
    
}
