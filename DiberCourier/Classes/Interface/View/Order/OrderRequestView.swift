//
//  OrderRequestView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/3/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

protocol OrderRequestViewDelegate: class {
    func executeOrderDidPress()
    func cancelRequestDidPress(from: OrderRequestView, request: RequestView)
}

internal enum State {
    case requestNotFound
    case requestExists
    case canceled_by_customer
    case canceled_by_courier
}

class OrderRequestView: UIView {
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var cancelRequestButton: UIButton!
    @IBOutlet weak var executeButton: UIButton!
    
    weak var delegate: OrderRequestViewDelegate?
    fileprivate(set) var state: State = .requestNotFound {
        didSet {
            updateState()
        }
    }
    
    private var request: RequestView?
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Actions
    
    @IBAction func executeOrderDidPress(_ sender: Any) {
        delegate?.executeOrderDidPress()
    }
    
    @IBAction func cancelRequestDidPress(_ sender: Any) {
        guard let request = request else { return }
        delegate?.cancelRequestDidPress(from: self, request: request)
    }
    
    // MARK: Public API
    
    func set(order: OrderView) {
        let courierId = PreferenceManager.shared.userId
        getRequest(orderId: order.id, courierId: courierId)
    }
    
    // MARK: Networking
    
    private func getRequest(silent: Bool = false, orderId: Int, courierId: Int) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            // TODO remove mbgrogress, hide self instead
            MBProgressHUD.showAdded(to: self, animated: true)
        }
        
        RequestService.shared.getRequest(orderId: orderId, courierId: courierId) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_, animated: true)
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let request):
                self_.update(request)
            case .UnexpectedError(_):
                self_.state = .requestNotFound
            case .OfflineError:
                break
            }
        }
    }
    
    // MARK: Private
    
    private func update(_ request: RequestDTO) {
        self.request = RequestView.create(from: request)
        
        switch request.status {
        case .canceled_by_courier:
            self.state = .canceled_by_courier
        case .canceled_by_customer:
            self.state = .canceled_by_customer
        case .not_reviewed:
            self.state = .requestExists
        }
    }
    
    private func updateState() {
        if let request = self.request {
            switch request.status {
            case .canceled_by_courier:
                self.hintLabel.text = "You have canceled your request. Submit again?"
            case .canceled_by_customer:
                self.hintLabel.text = "Your request was rejected by the customer on \(request.date)"
            case .not_reviewed:
                self.hintLabel.text = "You have already submitted the request on \(request.date)"
            }
        } else {
            self.hintLabel.text = "You can submit request for this order"
        }
        
        self.executeButton.isHidden = state == .requestNotFound || state != .canceled_by_courier
        self.cancelRequestButton.isHidden = state != .requestExists
    }
    
}
