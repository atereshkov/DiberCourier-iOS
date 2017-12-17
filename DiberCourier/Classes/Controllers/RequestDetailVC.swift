//
//  RequestDetailVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/17/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import MBProgressHUD

class RequestDetailVC: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    var requestId: Int?
    fileprivate(set) var request: RequestView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        guard let requestId = requestId else { return }
        loadData(silent: false, id: requestId)
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func backButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelRequestDidPress(_ sender: Any) {
        let msg = "alert.request.cancel".localized()
        
        let ok = UIAlertAction(title: "alert.yes".localized(), style: .default, handler: { (action) in
            self.cancelRequest()
        })
        let cancel = UIAlertAction(title: "alert.cancel".localized(), style: .cancel) { (action) in }
        
        self.showAlert(with: "alert.request".localized(), and: msg, buttons: [ok, cancel])
    }
    
    // MARK: Helpers
    
    private func setup(_ request: RequestDTO) {
        let requestView = RequestView.create(from: request)
        self.request = requestView
        
        guard let request = self.request else { return }
        statusLabel.text = request.status.displayName()
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool, id: Int) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        RequestService.shared.getRequest(id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let request):
                self_.setup(request)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    private func cancelRequest() {
        guard let requestId = requestId else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        RequestService.shared.cancelRequest(id: requestId) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
            }
            
            switch result {
            case .Success():
                LogManager.log.info("Request canceled")
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}
