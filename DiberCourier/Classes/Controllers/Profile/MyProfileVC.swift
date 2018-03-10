//
//  MyProfileVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/4/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit
import MBProgressHUD

class MyProfileVC: UIViewController {
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        
        loadData(silent: false)
    }
    
    // MARK: Prepare segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let headerVC = segue.destination as? MyProfileHeaderVC {
            headerVC.delegate = self
        }
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // Logic
    
    fileprivate func signOut() {
        // TODO SignOut logic
        PreferenceManager.shared.token = ""
        
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let loginVc = loginStoryboard.instantiateInitialViewController() {
            self.present(loginVc, animated: true, completion: nil)
        }
    }
    
    private func showContent(_ show: Bool) {
        //self.view.isHidden = !show
    }
    
    private func setup(_ user: UserDTO) {
        let userView = UserView.create(from: user)
        // TODO map data to view
    }
    
}

// MARK: Networking

extension MyProfileVC {
    
    private func loadData(silent: Bool) {
        showContent(false)
        
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        UserService.shared.getUserProfileData() { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let user):
                self_.setup(user)
                self_.showContent(true)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}

// MARK: HeaderDelegate

extension MyProfileVC: MyProfileHeaderDelegate {
    
    func signOutButtonPressed(vc: MyProfileHeaderVC) {
        self.signOut()
    }
    
}
