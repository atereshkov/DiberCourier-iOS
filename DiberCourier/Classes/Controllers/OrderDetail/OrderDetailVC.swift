//
//  OrderDetailVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import MBProgressHUD
import Localize_Swift
import PopupDialog
import MapKit

protocol OrderDetailVCDelegate: class {
    func shouldPresentExecutionVC(from vc: OrderDetailVC, orderId: Int)
}

class OrderDetailVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailsView: OrderDetailView!
    @IBOutlet weak var requestView: OrderRequestView!
    @IBOutlet weak var priceView: OrderPriceView!
    @IBOutlet weak var distanceView: OrderDistanceView!
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    weak var delegate: OrderDetailVCDelegate? = nil
    
    var orderId: Int?
    fileprivate(set) var order: OrderView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        loadData(silent: false)
        
        requestView.delegate = self
        detailsView.delegate = self
    }
    
    // MARK: Prepare segues
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func backButtonDidPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helpers
    
    private func setup(_ order: OrderDTO) {
        let orderView = OrderView.create(from: order)
        self.order = orderView
        
        guard let order = self.order else { return }
        detailsView.set(order: order)
        priceView.setPrice(order.price)
        requestView.set(order: order)
        
        guard let latitude1 = order.addressFrom.latitude, let longitude1 = order.addressFrom.longitude else { return }
        guard let latitude2 = order.addressTo.latitude, let longitude2 = order.addressTo.longitude else { return }
        let firstCord = CLLocationCoordinate2D(latitude: latitude1, longitude: longitude1)
        let secondCord = CLLocationCoordinate2D(latitude: latitude2, longitude: longitude2)
        self.showRouteOnMap(pickupCoordinate: firstCord, destinationCoordinate: secondCord)
        
        let loc1 = CLLocation(latitude: latitude1, longitude: longitude1)
        let loc2 = CLLocation(latitude: latitude2, longitude: longitude2)
        let distance: CLLocationDistance = loc1.distance(from: loc2)
        distanceView.set(distance: distance)
    }
    
    private func showContent(_ show: Bool) {
        detailsView.isHidden = !show
        requestView.isHidden = !show
        priceView.isHidden = !show
    }
    
}

// MARK: OrderRequestViewDelegate

extension OrderDetailVC: OrderRequestViewDelegate {
    
    func startOrderExecution() {
        let msg = "alert.order.start.execution".localized()
        let cancel = UIAlertAction(title: "alert.cancel".localized(), style: .cancel) { (action) in }
        let ok = UIAlertAction(title: "alert.yes".localized(), style: .default, handler: { (action) in
            self.startOrder()
        })
        
        self.showAlert(with: "alert.order".localized(), and: msg, buttons: [ok, cancel])
    }
    
    func executeOrderDidPress() {
        let msg = "alert.request.make".localized()
        let cancel = UIAlertAction(title: "alert.cancel".localized(), style: .cancel) { (action) in }
        let ok = UIAlertAction(title: "alert.yes".localized(), style: .default, handler: { (action) in
            self.addRequest()
        })
        
        self.showAlert(with: "alert.request".localized(), and: msg, buttons: [ok, cancel])
    }
    
    func cancelRequestDidPress(from: OrderRequestView, request: RequestView) {
        let msg = "alert.request.cancel".localized()
        let cancel = UIAlertAction(title: "alert.cancel".localized(), style: .cancel) { (action) in }
        let ok = UIAlertAction(title: "alert.yes".localized(), style: .default, handler: { (action) in
            self.cancelRequest(id: request.id)
        })
        
        self.showAlert(with: "alert.request".localized(), and: msg, buttons: [ok, cancel])
    }
    
}

// MARK: OrderDetailViewDelegate

extension OrderDetailVC: OrderDetailViewDelegate {
    
    func showToAddressDetails() {
        guard let address = self.order?.addressTo else { return }
        
        let title = "Destination address"
        let message = "\(address.country), \(address.city), \(address.address)"
        let popup = PopupDialog(title: title, message: message)
        
        let clipboardButton = DefaultButton(title: "COPY TO CLIPBOARD", dismissOnTap: false) {
            let strAddress = "\(address.country), \(address.city), \(address.address)"
            UIPasteboard.general.string = strAddress
        }
        
        let mapButton = DefaultButton(title: "SHOW ON MAP") {
            let mapLinkQuery = GoogleMaps.apiURL + "\(address.country), \(address.city), \(address.address)"
            let link = mapLinkQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            if let link = link, let url = URL(string: link) {
                Swift.print("URL: \(url)")
                UIApplication.shared.open(url)
            }
        }
        
        let closeButton = CancelButton(title: "CLOSE") { }
        
        popup.addButtons([clipboardButton, mapButton, closeButton])
        self.present(popup, animated: true, completion: nil)
    }
    
    func showFromAddreesDetails() {
        guard let address = self.order?.addressFrom else { return }
        
        let title = "Address from"
        let message = "\(address.country), \(address.city), \(address.address)"
        let popup = PopupDialog(title: title, message: message)
        
        let clipboardButton = DefaultButton(title: "COPY TO CLIPBOARD", dismissOnTap: false) {
            let strAddress = "\(address.country), \(address.city), \(address.address)"
            UIPasteboard.general.string = strAddress
        }
        
        let mapButton = DefaultButton(title: "SHOW ON MAP") {
            let mapLinkQuery = GoogleMaps.apiURL + "\(address.country), \(address.city), \(address.address)"
            let link = mapLinkQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            if let link = link, let url = URL(string: link) {
                Swift.print("URL: \(url)")
                UIApplication.shared.open(url)
            }
        }
        
        let closeButton = CancelButton(title: "CLOSE") { }
        
        popup.addButtons([clipboardButton, mapButton, closeButton])
        self.present(popup, animated: true, completion: nil)
    }
    
}

// MARK: MKMapViewDelegate

extension OrderDetailVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        renderer.lineWidth = 3.0
        return renderer
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            // Uncomment to get region zoom in of polygon rect
            //let rect = route.polyline.boundingMapRect
            //self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
}

// MARK: Networking

extension OrderDetailVC {
    
    private func loadData(silent: Bool) {
        showContent(false)
        
        guard let id = orderId else { return }
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        OrderService.shared.getOrder(id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let order):
                self_.setup(order)
                self_.showContent(true)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    private func addRequest() {
        guard let id = orderId else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        RequestService.shared.addRequest(orderId: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
            }
            
            switch result {
            case .Success():
                self_.showAlert(title: "Request added", message: "Request added succesfully. Don't start order executing until client approval")
                LogManager.log.info("Request added succesfully")
                
                self_.loadData(silent: true)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    private func cancelRequest(id: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        RequestService.shared.cancelRequest(id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
            }
            
            switch result {
            case .Success():
                self_.showAlert(title: "Request canceled", message: "Request was canceled succesfully")
                LogManager.log.info("Request with id \(id) canceled")
                
                self_.loadData(silent: true)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    private func startOrder() {
        guard let id = orderId else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let status: OrderExecution = .in_progress
        OrderExecutionService.shared.startOrder(id: id, status: status) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
            }
            
            switch result {
            case .Success():
                guard let order = self_.order else { return }
                LogManager.log.info("Order with id \(id) started")
                
                let title = "Order execution started"
                let msg = "You need to deliver this order by \(order.date.toString())"
                self_.showAlert(title: title, message: msg, callback: {
                    self_.delegate?.shouldPresentExecutionVC(from: self_, orderId: id)
                })
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}
