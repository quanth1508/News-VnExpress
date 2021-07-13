//
//  BookMarkViewController.swift
//  News VnExpress
//
//  Created by Quan Tran on 09/07/2021.
//

import UIKit
import RealmSwift
import SafariServices
//import SwipeCellKit

class BookMarkViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableViewBookMark: UITableView!
    @IBOutlet weak var deleteTotal: UIBarButtonItem!
    
    var newBookmark: Results<BookmarkModel>?
    
    var bookMarkCell: BookMarkTableViewCell?
    
    let realmServices = RealmServices()
    
    //MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteTotal.title = "Delete All"
        
        tableViewBookMark.dataSource = self
        tableViewBookMark.delegate = self

        bookMarkCell?.bookmarkViewController = self
        
        realmServices.bookmarkViewController = self
        
        tableViewBookMark.register(UINib(nibName: Contants.Identifier.cellBookmarkNibName, bundle: nil), forCellReuseIdentifier: Contants.Identifier.cellBookmarkIdentifier)
        
        tableViewBookMark.estimatedRowHeight = 140
        tableViewBookMark.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        title = "Bookmark"
        
        navigationController?.navigationBar.prefersLargeTitles = true
    
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(name: "System-Bold", size: 25), size: 25),
             .foregroundColor: UIColor(named: Contants.Color.textBarColor)!]
        
        navigationController?.navigationBar.tintColor = UIColor(named: Contants.Color.textBarColor)
        navigationController?.navigationBar.barTintColor = UIColor(named: Contants.Color.barColor)
        
        loadBookmark()
    }
    
    //MARK: - Functions
    
    @IBAction func didTapDeleteAll(_ sender: UIBarButtonItem) {
        
        // Set up Alert when user click Delete All two case: Exist bookmark or Not bookmark in realm database
        if newBookmark?.count != 0 {
            
            let alert = UIAlertController(title: "Delete \"All News Bookmark\"?", message: "Delete all News Bookmark will remove all Bookmark data you saved.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                
                // Delete all data in realm
                self.realmServices.deleteAllData()

            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Don't Delete All News Bookmark!", message: "No News Bookmark saved.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    // Fetch Data to Bookmark tableview from realm database
    private func loadBookmark() {
        newBookmark = Contants.realm.objects(BookmarkModel.self)
        print("count bookmark saved = \(newBookmark?.count ?? 1)")
        tableViewBookMark.reloadData()
    }
}

//MARK: - TableView Book Mark DateSource

extension BookMarkViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newBookmark?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewBookMark.dequeueReusableCell(withIdentifier: Contants.Identifier.cellBookmarkIdentifier,
                                                         for: indexPath) as! BookMarkTableViewCell
        let newItem = newBookmark?[indexPath.row]
        cell.item = newItem
        
        cell.bookmarkViewController = self
        
        // Swipe cell kit delegate
//        cell.delegate = self
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let del = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (context, view, completion) in
                if let bookMarkItem = self?.newBookmark?[indexPath.row] {
                    let bookmarkItemResult = Contants.realm.objects(BookmarkModel.self).filter("title = %@", bookMarkItem.title)
                    self?.realmServices.deleteData(deleteObj: bookmarkItemResult)
                }
            }
            return UISwipeActionsConfiguration(actions:[del])
        }
    
}

//MARK: - TableView Book Mark Delegate

extension BookMarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = newBookmark?[indexPath.row]
        
        if let urlLink = URL(string: item?.link ?? "") {
            let safariVC = SFSafariViewController(url: urlLink)
            present(safariVC, animated: true, completion: nil)
        }
    }
}

//MARK: - SwipeCell Delegate

/*
extension BookMarkViewController: SwipeTableViewCellDelegate {
    
    // Set up Swipe cell do Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
                
                if let bookMarkItem = self?.newBookmark?[indexPath.row] {
                    let bookmarkItemResult = Contants.realm.objects(BookmarkModel.self).filter("title = %@", bookMarkItem.title)
                    self?.realmServices.deleteData(deleteObj: bookmarkItemResult)
                }
            }
        
            // Customize the action appearance
            deleteAction.image = UIImage(named: "Trush")
            return [deleteAction]
    }
    
    // Set up options for Swipe Cell
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
 */
