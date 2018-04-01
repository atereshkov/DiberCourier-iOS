//
//  RequestDetailVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/17/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import SVProgressHUD

class RequestDetailVC: UIViewController {
    
    @IBOutlet weak var cancelRequestButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    
    private var topHeaderVC: TopHeaderVC? = nil
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    var requestId: Int?
    fileprivate(set) var request: RequestView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        guard let requestId = requestId else { return }
        loadData(silent: false, id: requestId)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOrderTap(_:)))
        orderLabel.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let headerVC = segue.destination as? TopHeaderVC {
            headerVC.delegate = self
        }
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @objc func handleOrderTap(_ sender: UITapGestureRecognizer) {
        guard let orderId = self.request?.order.id else { return }
        let storyboard = UIStoryboard(name: Storyboards.order.rawValue, bundle: nil)
        
        if let orderNavVC = storyboard.instantiateInitialViewController() as? UINavigationController,
            let orderDetailVC = orderNavVC.rootViewController as? OrderDetailVC {
            orderDetailVC.orderId = orderId
            self.navigationController?.pushViewController(orderDetailVC, animated: true)
        }
    }
    
    @IBAction func cancelRequestDidPress(_ sender: Any) {
        let msg = "alert.request.cancel".localized()
        let cancel = UIAlertAction(title: "alert.cancel".localized(), style: .cancel) { (action) in }
        let ok = UIAlertAction(title: "alert.yes".localized(), style: .default, handler: { (action) in
            self.cancelRequest()
        })
        
        self.showAlert(with: "alert.request".localized(), and: msg, buttons: [ok, cancel])
    }
    
    // MARK: Helpers
    
    private func setup(_ request: RequestDTO) {
        let requestView = RequestView.create(from: request)
        self.request = requestView
        
        guard let request = self.request else { return }
        statusLabel.text = request.status.displayName()
        dateLabel.text = request.date.toString()
        orderLabel.text = "#\(request.order.id)"
        
        switch request.status {
        case .canceled_by_courier:
            self.cancelRequestButton.isHidden = true
        case .canceled_by_customer:
            self.cancelRequestButton.isHidden = true
        case .not_reviewed:
            self.cancelRequestButton.isHidden = false
        case .accepted:
            self.cancelRequestButton.isHidden = true
        }
        
        //if let headerVC = topHeaderVC {
            // set header label "Request #123"
        //}
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool, id: Int) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            SVProgressHUD.show()
        }
        
        RequestService.shared.getRequest(id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
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
        SVProgressHUD.show()
        
        RequestService.shared.cancelRequest(id: requestId) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
            }
            
            switch result {
            case .Success():
                guard let requestId = self_.requestId else { return }
                self_.loadData(silent: true, id: requestId)
                LogManager.log.info("Request canceled")
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}

extension RequestDetailVC: TopHeaderVCDelegate {
    
    func backButtonPressed(vc: TopHeaderVC) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
