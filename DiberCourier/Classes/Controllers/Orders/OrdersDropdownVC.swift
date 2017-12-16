//
//  OrdersDropdownVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/16/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit

enum DropdownState {
    case collapsed
    case expanded
}

protocol OrdersDropdownDelegate: class {
    func stateChanged(controller: OrdersDropdownVC, to state: DropdownState)
}

class OrdersDropdownVC: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private(set) var state: DropdownState = .collapsed {
        didSet {
            updateIcon()
        }
    }
    
    weak var delegate: OrdersDropdownDelegate? = nil
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        
        updateIcon()
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func changeStateAction(_ sender: Any) {
        state = state == .collapsed ? .expanded : .collapsed
        delegate?.stateChanged(controller: self, to: state)
    }
    
    // MARK: Private
    
    private func updateIcon() {
        UIView.transition(with: imageView,
                          duration: 0.15,
                          options: .transitionCrossDissolve,
                          animations: { self.imageView.image = self.state == .collapsed ? #imageLiteral(resourceName: "ic_arrow_drop_down") : #imageLiteral(resourceName: "ic_arrow_drop_up") },
                          completion: nil)
    }
    
    // MARK: Public API
    
    func setSelected(_ value: String) {
        textLabel.text = value
    }
    
    func setState(_ state: DropdownState) {
        self.state = state
        delegate?.stateChanged(controller: self, to: state)
    }
    
}
