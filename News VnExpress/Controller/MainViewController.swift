//
//  MainViewController.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import UIKit
import SideMenu
import SafariServices
import UserNotifications

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
    
    var categories = FScreen.allCases
    
    // RefreshControl
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
        
        title = "Trang chủ"
        circleLoading.isHidden = true
        
        // Set up sidemenu to MainViewController
        menu = SideMenuNavigationController(rootViewController: menuSide)
        
        menu!.alwaysAnimate = true
        menu!.leftSide = true
        menu?.presentationStyle = .viewSlideOutMenuIn
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        self.menuSide.delegate = self
        
        // Set up table view news
        tableViewNews.dataSource = self
        tableViewNews.delegate = self
        
        tableViewNews.register(UINib(nibName: Contants.Identifier.cellNewsNibName, bundle: nil), forCellReuseIdentifier: Contants.Identifier.cellNewsIdentifier)
        
        tableViewNews.estimatedRowHeight = 140
        tableViewNews.rowHeight = UITableView.automaticDimension
        
        tableViewNews.backgroundView = self.refresh
        
        fetchSideMenu(fromURl: "https://vnexpress.net/rss/tin-moi-nhat.rss")
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { grented, error in
            
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Hey, i'm notification"
        content.body = "Look at me!"
        
        let date = Date().addingTimeInterval(6)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor(name: "System-Bold", size: 25), size: 25),
             .foregroundColor: UIColor(named: Contants.Color.textBarColor)!]
        
        navigationController?.navigationBar.tintColor = UIColor(named: Contants.Color.textBarColor)
        navigationController?.navigationBar.barTintColor = UIColor(named: Contants.Color.barColor)
        
        DispatchQueue.main.async { [weak self] in
            self?.tableViewNews.reloadData()
        }
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
    
    // Function use for refresh control tableview news
    @objc func refreshSelf(_ sender: UIRefreshControl) {
        tableViewNews.alpha = 0.5
        self.view.isUserInteractionEnabled = false
        
        let currentTitle = findCaseTitle(categories: categories, titleString: title!)
        fetchDataRefresh(item: currentTitle)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.refresh.endRefreshing()
            self?.tableViewNews.alpha = 1
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    // Function use for animate circle refresh
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

        guard let titleString = self.title else {
            return
        }
        
        let currentTitle = findCaseTitle(categories: self.categories, titleString: titleString)
        fetchDataRefresh(item: currentTitle)
        
        group.notify(queue: .main) { [weak self] in
            Timer.scheduledTimer(timeInterval: 1.5, target: self!, selector: #selector(self?.stopRefreshing), userInfo: nil, repeats: false)
        }
    }
    
    // Fetch Data from url
    private func fetchSideMenu(fromURl url: String) {
        newsManager.fetchData(from: url) { [weak self] (item) in
            self?.items = item
            DispatchQueue.main.async {
                self?.tableViewNews.reloadData()
            }
        }
    }
    
    func fetchDataRefresh(item: FScreen) {
        switch item {
        case .trangchu:
            fetchSideMenu(fromURl: UrlFscreen.trangchu.rawValue)
        case .thegioi:
            fetchSideMenu(fromURl: UrlFscreen.thegioi.rawValue)
        case .thoisu:
            fetchSideMenu(fromURl: UrlFscreen.thoisu.rawValue)
        case .kinhdoanh:
            fetchSideMenu(fromURl: UrlFscreen.kinhdoanh.rawValue)
        case .startup:
            fetchSideMenu(fromURl: UrlFscreen.startup.rawValue)
        case .giaitri:
            fetchSideMenu(fromURl: UrlFscreen.giaitri.rawValue)
        case .thethao:
            fetchSideMenu(fromURl: UrlFscreen.thethao.rawValue)
        case .phapluat:
            fetchSideMenu(fromURl: UrlFscreen.phapluat.rawValue)
        case .giaoduc:
            fetchSideMenu(fromURl: UrlFscreen.giaoduc.rawValue)
        case .tinnoibat:
            fetchSideMenu(fromURl: UrlFscreen.tinnoibat.rawValue)
        case .suckhoe:
            fetchSideMenu(fromURl: UrlFscreen.suckhoe.rawValue)
        case .doisong:
            fetchSideMenu(fromURl: UrlFscreen.doisong.rawValue)
        case .dulich:
            fetchSideMenu(fromURl: UrlFscreen.dulich.rawValue)
        case .khoahoc:
            fetchSideMenu(fromURl: UrlFscreen.khoahoc.rawValue)
        case .sohoa:
            fetchSideMenu(fromURl: UrlFscreen.sohoa.rawValue)
        case .xe:
            fetchSideMenu(fromURl: UrlFscreen.xe.rawValue)
        case .ykien:
            fetchSideMenu(fromURl: UrlFscreen.ykien.rawValue)
        case .tamsu:
            fetchSideMenu(fromURl: UrlFscreen.tamsu.rawValue)
        case .cuoi:
            fetchSideMenu(fromURl: UrlFscreen.cuoi.rawValue)
        case .tinxemnhieu:
            fetchSideMenu(fromURl: UrlFscreen.tinxemnhieu.rawValue)
        }
    }
    
    func findCaseTitle(categories: [FScreen], titleString: String) -> FScreen {
        for index in categories.indices {
            if categories[index].rawValue == titleString {
                print("current categories: \(categories[index].rawValue)")
                return categories[index]
            }
        }
        return categories[0]
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
        
        guard var items = items?[indexPath.row]  else {
            return cell
        }
        
        cell.item = items
        
        cell.mainViewController = self
        
        let result = Contants.realm.objects(BookmarkModel.self).filter("title = %@", items.title)
        
        // check news exist in realm database
        if result.count != 0 {
            cell.bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            cell.bookMarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        items.bookmarkTaped = (result.count != 0) ? true : false
        
        cell.bookMarkButton.imageView?.image = (items.bookmarkTaped) ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        
        // call back state bookmark news
        cell.bookmarkTapAction = { (isTapped) in
            self.items?[indexPath.row].bookmarkTaped = isTapped
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    // Animation cell will appear display
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
        self.fetchDataRefresh(item: item)

        self.menu?.dismiss(animated: true, completion: nil)
    }
}
