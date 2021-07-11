//
//  MenuTableViewController.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import UIKit

//MARK: - Protocols

protocol SideMenuDelegate: AnyObject {
    func didTapSideMenuItem(item: FScreen)
}

class MenuTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    var contentsMenu = FScreen.allCases
    weak var delegate: SideMenuDelegate?
    var isTapped = 0
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Contants.Identifier.cellMenuNibName, bundle: nil), forCellReuseIdentifier: Contants.Identifier.cellMenuIdentifier)
        title = "VnExpress News"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.backgroundColor = UIColor(named: Contants.Color.barColor)
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(name: "System-Bold", size: 21), size: 21),
             .foregroundColor: UIColor(named: Contants.Color.textBarColor)!]
    }

    // MARK: - Table view Menu datasource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsMenu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Contants.Identifier.cellMenuIdentifier, for: indexPath) as! MenuTableViewCell
        
        cell.contentCell = contentsMenu[indexPath.row].rawValue
        cell.backgroundColor = UIColor(named: Contants.Color.barColor)
        
        cell.content.font = (isTapped == indexPath.row) ? UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold) : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        
        return cell
    }
    
    // MARK: - Table view Menu delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedSideMenuItem = contentsMenu[indexPath.row]
        delegate?.didTapSideMenuItem(item: selectedSideMenuItem)
  
        tableView.beginUpdates()
        
        isTapped = indexPath.row
        tableView.reloadData()
        
        tableView.endUpdates()
    }
}
