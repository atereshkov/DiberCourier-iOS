//
//  OrderRequestView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/3/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

protocol OrderRequestViewDelegate: class {
    func executeOrderDidPress()
    func cancelRequestDidPress(from: OrderRequestView, request: RequestView)
    func startOrderExecution()
}

internal enum State {
    case requestNotFound
    case requestExists
    case canceled_by_customer
    case canceled_by_courier
    case accepted
}

class OrderRequestView: UIView {
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var cancelRequestButton: UIButton!
    @IBOutlet weak var executeButton: UIButton!
    @IBOutlet weak var startOrderButton: UIButton!
    
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
    
    @IBAction func startOrderDidPress(_ sender: Any) {
        delegate?.startOrderExecution()
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
            SVProgressHUD.show()
        }
        
        LogManager.log.info("Get request with orderId: \(orderId) and courierId: \(courierId)")
        RequestService.shared.getRequest(orderId: orderId, courierId: courierId) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let request):
                self_.update(request)
            case .UnexpectedError(let error):
                LogManager.log.error("Error during getRequest: \(String(describing: error))")
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
        case .accepted:
            self.state = .accepted
        }
    }
    
    private func updateState() {
        if let request = self.request {
            switch request.status {
            case .canceled_by_courier:
                self.hintLabel.text = "You have canceled your request. Submit again?"
            case .canceled_by_customer:
                // todo use modified date instead creation date
                self.hintLabel.text = "Your request was rejected by the customer on \(request.date.toString())"
            case .not_reviewed:
                // todo use modified date instead creation date
                self.hintLabel.text = "You have already submitted the request on \(request.date.toString())"
            case .accepted:
                self.hintLabel.text = "Your request was accepted by the customer."
                self.startOrderButton.isHidden = false
            }
        } else {
            self.hintLabel.text = "You can submit request for this order"
        }
        
        self.executeButton.isHidden = state != .requestNotFound && state != .canceled_by_courier
        self.cancelRequestButton.isHidden = state != .requestExists
    }
    
}
