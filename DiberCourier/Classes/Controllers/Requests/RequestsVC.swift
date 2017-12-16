//
//  RequestsVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/17/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import MBProgressHUD

class RequestsVC: UIViewController {
    
    private var requestsTableVC: RequestsTableVC? = nil
    //private var requestDetailVC: RequestDetailVC? = nil
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        loadData(silent: false)
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Prepare segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.requestsTable.rawValue {
            if let requestsTableVC = segue.destination as? RequestsTableVC {
                requestsTableVC.delegate = self
                self.requestsTableVC = requestsTableVC
            }
        }
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        RequestService.shared.getRequests() { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let requests):
                LogManager.log.info("Got requests: \(requests.count)")
                self_.setup(requests)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    // MARK: Helpers
    
    private func setup(_ requests: [RequestDTO]) {
        guard let requestsTableVC = self.requestsTableVC else { return }
        let requestsDVO = RequestView.from(requests: requests)
        requestsTableVC.addRequests(requestsDVO)
    }
    
}

// MARK: RequestsTableDelegate

extension RequestsVC: RequestsTableDelegate {
    
    func didReachLastCell(page: Int) {
        //self.loadData(silent: false)
    }
    
    func didSelectRequest(request: RequestView) {
        /*
        let storyboard = UIStoryboard(name: Storyboards.order.rawValue, bundle: nil)
        
        if let orderNavVC = storyboard.instantiateInitialViewController() as? UINavigationController,
            let orderDetailVC = orderNavVC.rootViewController as? OrderDetailVC {
            orderDetailVC.orderId = order.id
            self.present(orderNavVC, animated: true, completion: nil)
        }
        */
    }
    
    func didPullRefresh() {
        guard let requestsTableVC = self.requestsTableVC else { return }
        requestsTableVC.removeAll()
        self.loadData(silent: false)
    }
    
}
