//
//  AlertControllerHelper.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import Localize_Swift

extension UIAlertController {
    
    // MARK: Util
    
    static func showErrorAlertController(error: Error?, fromViewController viewController: UIViewController) {
        UIAlertController.showAlert(
            title: "alert.error.title".localized(),
            message: error?.localizedDescription,
            from: viewController)
    }
    
    static func showErrorAlertController(with message: String, from VC: UIViewController) {
        UIAlertController.showAlert(
            title: "alert.error.title".localized(), message: message, from: VC)
    }
    
    static func showAlertController(title: String? = nil, message: String? = nil, fromViewController viewController: UIViewController) {
        let errorTitle = title ?? "alert.error.title".localized()
        
        let errorMessage = message ?? "\("alert.error.unexpected.description".localized()) \("alert.error.unexpected.recovery".localized())"
        
        UIAlertController.showAlert(title: errorTitle, message: errorMessage, from: viewController)
    }
    
    // MARK: Offline error
    
    static func showOfflineErrorAlert(fromViewController controller: UIViewController) {
        UIAlertController.showAlert(
            title: "alert.error.title".localized(),
            message: "alert.offline.message".localized(),
            from: controller)
    }
    
    // MARK: Login errors
    
    static func showInvalidLoginDataAlert(fromViewController controller: UIViewController) {
        UIAlertController.showAlert(
            title: "alert.error.title".localized(),
            message: "alert.login.user.error.message".localized(),
            from: controller)
    }
    
    // MARK: Common
    
    static func showAlert(title: String?, message: String?, from controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "alert.ok".localized(), style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    func showOfflineErrorAlert() {
        UIAlertController.showOfflineErrorAlert(fromViewController: self)
    }
    
    func showMessageErrorAlert(message: String) {
        UIAlertController.showAlertController(title: "alert.error.title".localized(), message: message,
                                              fromViewController: self)
    }
    
    func showUnexpectedErrorAlert(error: Error? = nil) {
        if let err = error {
            UIAlertController.showAlertController(title: "alert.error.title".localized(),
                                                  message: err.localizedDescription,
                                                  fromViewController: self)
        } else {
            UIAlertController.showAlertController(fromViewController: self)
        }
    }
    
    func showAlert(title : String?, message: String?) {
        UIAlertController.showAlert(title: title, message: message, from: self)
    }
    
    func showMissingErrorAlert() {
        UIAlertController.showAlertController(title: "alert.error.title".localized(),
                                              message: "alert.error.unexpected.nodata".localized(),
                                              fromViewController: self)
        
    }
    
    func showAuthExpiredAlert(callback: (() -> ())? = nil) {
        let alert = UIAlertController(title: "alert.error.title".localized(),
                                      message: "alert.session.expired.error.msg".localized(),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "alert.ok".localized(),
                                      style: UIAlertActionStyle.default,
                                      handler: { (action) in
                                        callback?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title : String?, message: String?, callback: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "alert.ok".localized(), style: .default, handler: { (action) in
            callback?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(with title: String, and message: String,
                   buttons : [(title: String, style : UIAlertActionStyle, callback: (() -> ())?)]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for button in buttons {
            let defaultAction = UIAlertAction(title: button.title, style: button.style, handler: { action in
                button.callback?()
            })
            alertController.addAction(defaultAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(with title: String, and message: String, buttons: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for button in buttons {
            alertController.addAction(button)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
}

