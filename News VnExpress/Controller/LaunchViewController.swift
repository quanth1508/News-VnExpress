//
//  LaunchViewController.swift
//  News VnExpress
//
//  Created by Quan Tran on 07/07/2021.
//

import UIKit

class LaunchViewController: UIViewController  {
    
    //MARK: - IB Outlet
    
    @IBOutlet weak var launchImageView: UIImageView!
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateLaunchView()
        
        Timer.scheduledTimer(timeInterval: 2.1, target: self, selector: #selector(self.dismissSelf), userInfo: nil, repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    //MARK: - Functions
    
    @objc func dismissSelf() {
        self.performSegue(withIdentifier: "rootView", sender: nil)
    }
    
    func animateLaunchView() {
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseInOut]) {
            self.launchImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.launchImageView.transform = .identity
        } completion: { _ in
            self.animateLaunchView()
        }
    }
    
}
