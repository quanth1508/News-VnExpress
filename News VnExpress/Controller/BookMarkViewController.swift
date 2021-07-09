//
//  BookMarkViewController.swift
//  News VnExpress
//
//  Created by Quan Tran on 08/07/2021.
//

import UIKit
import RealmSwift
import SafariServices
import SwipeCellKit

class BookMarkViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableViewBookMark: UITableView!
    @IBOutlet weak var deleteTotal: UIBarButtonItem!
    
    var newBookmark: Results<BookmarkModel>?
    
    var newsTableCell: NewsTableViewCell?
    
    var bookMarkCell: BookMarkTableViewCell?
    
    //MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteTotal.title = "Delete All"
        
        tableViewBookMark.dataSource = self
        tableViewBookMark.delegate = self
        
        newsTableCell?.bookMarkViewController = self
        bookMarkCell?.bookmarkVC = self
        
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
        do {
            try Contants.realm.write({
                Contants.realm.deleteAll()
                print("deleded all")
            })
        }
        catch {
            print("error remove all: \(error.localizedDescription)")
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableViewBookMark.reloadData()
        }
    }
    
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
        
        // swipe cell kit delegate
        cell.delegate = self
        
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - TableView Book Mark Delegate

extension BookMarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = newBookmark?[indexPath.row]
        
        if let urlLink = URL(string: item?.link ?? "") {
            let safariVc = SFSafariViewController(url: urlLink)
            present(safariVc, animated: true, completion: nil)
        }
    }
}

//MARK: - SwipeCell Delegate

extension BookMarkViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
                
                if let bookMarkItem = self?.newBookmark?[indexPath.row] {
                    do {
                        try Contants.realm.write({
                            Contants.realm.delete(bookMarkItem)
                        })
                    }
                    catch {
                        print("error delete \(error.localizedDescription)")
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.tableViewBookMark.reloadData()
                    }
                }
            }
        
            // customize the action appearance
            deleteAction.image = UIImage(named: "Trush")
            return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
