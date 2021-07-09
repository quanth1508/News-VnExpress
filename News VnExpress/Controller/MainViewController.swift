//
//  MainViewController.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import UIKit
import SideMenu
import SafariServices

class MainViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableViewNews: UITableView!
    @IBOutlet weak var didTapMenuButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var circleLoading: CircleLoading!
    
    var menu: SideMenuNavigationController?

    var newsManager = NewsManager()
    
    var items: [NewsModel]?
    
    let menuSide = MenuTableViewController()
    
    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = UIColor(named: Contants.Color.textBarColor)
        refreshControl.addTarget(self, action: #selector(refreshSelf(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleLoading.isHidden = true
        
        menu = SideMenuNavigationController(rootViewController: menuSide)
        
        menu!.alwaysAnimate = true
        menu!.leftSide = true
        menu?.presentationStyle = .viewSlideOutMenuIn
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        tableViewNews.dataSource = self
        tableViewNews.delegate = self
//        newsManager.mainViewController = self
        self.menuSide.delegate = self
        
        tableViewNews.register(UINib(nibName: Contants.Identifier.cellNewsNibName, bundle: nil), forCellReuseIdentifier: Contants.Identifier.cellNewsIdentifier)
    
        tableViewNews.estimatedRowHeight = 140
        tableViewNews.rowHeight = UITableView.automaticDimension
        
        tableViewNews.backgroundView = self.refresh
        
        fetch(fromURl: "https://vnexpress.net/rss/tin-moi-nhat.rss")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        title = "Trang chủ"
        
        navigationController?.navigationBar.prefersLargeTitles = true
    
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(name: "System-Bold", size: 25), size: 25),
             .foregroundColor: UIColor(named: Contants.Color.textBarColor)!]
        
        navigationController?.navigationBar.tintColor = UIColor(named: Contants.Color.textBarColor)
        navigationController?.navigationBar.barTintColor = UIColor(named: Contants.Color.barColor)
    }
    
    //MARK: - IB Action
    
    @IBAction func didTapMenu(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func didTapRefresh(_ sender: Any) {
        tableViewNews.isHidden = true
        refreshButton.isEnabled = false
        circleLoading.isHidden = false
        
        animateLoad()
    }
    
    //MARK: - Functions
    
    @objc func refreshSelf(_ sender: UIRefreshControl) {
        tableViewNews.alpha = 0.5
        self.view.isUserInteractionEnabled = false
        
        DispatchQueue.main.async { [weak self] in
            self?.tableViewNews.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.refresh.endRefreshing()
            self?.tableViewNews.alpha = 1
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    @objc func stopRefreshing() {
        tableViewNews.isHidden = false
        circleLoading.isHidden = true
        refreshButton.isEnabled = true
    }
    
    // Set up animation for button refresh
    private func animateLoad() {
        let group = DispatchGroup()
        
        group.enter()
        self.circleLoading.animateCircle(duration: 1.5)
        group.leave()
        
        group.notify(queue: .main) { [weak self] in
            self?.tableViewNews.reloadData()
            Timer.scheduledTimer(timeInterval: 1.5, target: self!, selector: #selector(self?.stopRefreshing), userInfo: nil, repeats: false)
        }
    }
    
    // Fetch Data from url
    private func fetch(fromURl url: String) {
        newsManager.fetchData(from: url) { [weak self] (item) in
            self?.items = item
            DispatchQueue.main.async {
                self?.tableViewNews.reloadData()
            }
        }
    }
}

//MARK: - Extension Table View DataSource

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Contants.Identifier.cellNewsIdentifier, for: indexPath) as! NewsTableViewCell
        
        let items = items?[indexPath.row]
        cell.item = items
        
        if items?.bookmarkTaped == true {
            cell.bookMarkButton.imageView?.image = UIImage(systemName: "bookmark.fill")
        } else {
            cell.bookMarkButton.imageView?.image = UIImage(systemName: "bookmark")
        }
        
        cell.bookmarkTapAction = { (isTapped) in
            self.items?[indexPath.row].bookmarkTaped = isTapped
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0

        UIView.animate(withDuration: 0.2,
                       delay: 0.01,
                       options: .curveEaseInOut,
                       animations: {
                            cell.layer.transform = CATransform3DIdentity
                        cell.alpha = 1 },
                       completion: nil)
    }
    
}

//MARK: - Extension Table View Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = newsManager.news[indexPath.row]
        let urlString = item.link
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
}

//MARK: - Extension Side Menu Delegate

extension MainViewController: SideMenuDelegate {
    
    func didTapSideMenuItem(item: FScreen) {
        title = item.rawValue
        
        switch item {
        case .trangchu:
            fetch(fromURl: UrlFscreen.trangchu.rawValue)
        case .thegioi:
            fetch(fromURl: UrlFscreen.thegioi.rawValue)
        case .thoisu:
            fetch(fromURl: UrlFscreen.thoisu.rawValue)
        case .kinhdoanh:
            fetch(fromURl: UrlFscreen.kinhdoanh.rawValue)
        case .startup:
            fetch(fromURl: UrlFscreen.startup.rawValue)
        case .giaitri:
            fetch(fromURl: UrlFscreen.giaitri.rawValue)
        case .thethao:
            fetch(fromURl: UrlFscreen.thethao.rawValue)
        case .phapluat:
            fetch(fromURl: UrlFscreen.phapluat.rawValue)
        case .giaoduc:
            fetch(fromURl: UrlFscreen.giaoduc.rawValue)
        case .tinnoibat:
            fetch(fromURl: UrlFscreen.tinnoibat.rawValue)
        case .suckhoe:
            fetch(fromURl: UrlFscreen.suckhoe.rawValue)
        case .doisong:
            fetch(fromURl: UrlFscreen.doisong.rawValue)
        case .dulich:
            fetch(fromURl: UrlFscreen.dulich.rawValue)
        case .khoahoc:
            fetch(fromURl: UrlFscreen.khoahoc.rawValue)
        case .sohoa:
            fetch(fromURl: UrlFscreen.sohoa.rawValue)
        case .xe:
            fetch(fromURl: UrlFscreen.xe.rawValue)
        case .ykien:
            fetch(fromURl: UrlFscreen.ykien.rawValue)
        case .tamsu:
            fetch(fromURl: UrlFscreen.tamsu.rawValue)
        case .cuoi:
            fetch(fromURl: UrlFscreen.cuoi.rawValue)
        case .tinxemnhieu:
            fetch(fromURl: UrlFscreen.tinxemnhieu.rawValue)
        }
        self.menu?.dismiss(animated: true, completion: nil)
    }
    
}
