//
//  LoginVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import MBProgressHUD

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(false)
        
        //skipLoginIfAuthorized()
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func signInAction(_ sender: Any) {
        let login = loginField.text?.trim() ?? ""
        let password = passwordField.text?.trim() ?? ""
        
        self.perfomLogin(login, password)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
    }
    
    // MARK: Networking
    
    private func perfomLogin(_ login: String, _ password: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        AuthService.shared.getToken(login: login, password: password) { [weak self] (result) in
            guard let self_ = self else {
                return
            }
            
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
            }
            
            switch result {
            case .Success(_):
                PreferenceManager.shared.name = login
                self_.getUserInfo()
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            case .InvalidCredentials:
                self_.showMessageErrorAlert(message: "alert.login.bad.credentials".localized())
            }
        }
    }
    
    private func getUserInfo() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        UserService.shared.getUserInfo() { [weak self] (result) in
            guard let self_ = self else {
                return
            }
            
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
            }
            
            switch result {
            case .Success(let user):
                PreferenceManager.shared.userId = user.id
                self_.performSegue(withIdentifier: Segues.mainScreen.rawValue, sender: self)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}
