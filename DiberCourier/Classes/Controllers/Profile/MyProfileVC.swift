//
//  MyProfileVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/4/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyProfileVC: UIViewController {
    
    private var userInfoVC: UserInfoVC? = nil
    
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
        } else if let userInfoVC = segue.destination as? UserInfoVC {
            self.userInfoVC = userInfoVC
        } else if let supportVC = segue.destination as? MyProfileSupportVC {
            supportVC.delegate = self
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
        guard let userView = UserView.create(from: user) else { return }
        guard let userInfoVC = self.userInfoVC else { return }
        userInfoVC.setup(user: userView)
    }
    
}

// MARK: Networking

extension MyProfileVC {
    
    private func loadData(silent: Bool) {
        showContent(false)
        
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            SVProgressHUD.show()
        }
        
        UserService.shared.getUserProfileData() { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
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

// MARK: MyProfileSupportDelegate

extension MyProfileVC: MyProfileSupportDelegate {
    
    func contactButtonPressed(vc: MyProfileSupportVC) {
        let storyboard = UIStoryboard(name: Storyboards.tickets.rawValue, bundle: nil)
        
        if let contactNavVC = storyboard.instantiateInitialViewController() as? UINavigationController,
            let contactVC = contactNavVC.rootViewController as? TicketListVC {
            //contactVC.delegate = self
            self.navigationController?.pushViewController(contactVC, animated: true)
        }
    }
    
}
