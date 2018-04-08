//
//  OrderExecutionVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 1/21/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation
import SVProgressHUD
import Localize_Swift
import PopupDialog
import MapKit

class OrderExecutionVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailsView: OrderDetailView!
    @IBOutlet weak var priceView: OrderPriceView!
    @IBOutlet weak var distanceView: OrderDistanceView!
    @IBOutlet weak var orderStatusView: UILabel!
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    var orderId: Int?
    fileprivate(set) var order: OrderView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        loadData(silent: false)
        
        detailsView.delegate = self
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func backButtonDidPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeOrderDidPress(_ sender: Any) {
        let msg = "alert.order.complete".localized()
        let cancel = UIAlertAction(title: "alert.cancel".localized(), style: .cancel) { (action) in }
        let ok = UIAlertAction(title: "alert.yes".localized(), style: .default, handler: { (action) in
            self.completeOrder()
        })
        
        self.showAlert(with: "alert.order".localized(), and: msg, buttons: [ok, cancel])
    }
    
    @IBAction func cancelOrderDidPress(_ sender: Any) {
        let msg = "alert.order.cancel".localized()
        let cancel = UIAlertAction(title: "alert.cancel".localized(), style: .cancel) { (action) in }
        let ok = UIAlertAction(title: "alert.yes".localized(), style: .default, handler: { (action) in
            self.cancelOrder()
        })
        
        self.showAlert(with: "alert.order".localized(), and: msg, buttons: [ok, cancel])
    }
    
    // MARK: Helpers
    
    private func setup(_ order: OrderDTO) {
        let orderView = OrderView.create(from: order)
        self.order = orderView
        
        guard let order = self.order else { return }
        detailsView.set(order: order)
        priceView.setPrice(order.price)
        orderStatusView.text = order.status
        
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
    
}

// MARK: OrderDetailViewDelegate

extension OrderExecutionVC: OrderDetailViewDelegate {
    
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

extension OrderExecutionVC: MKMapViewDelegate {
    
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

extension OrderExecutionVC {
    
    fileprivate func loadData(silent: Bool) {
        guard let id = orderId else { return }
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            SVProgressHUD.show()
        }
        
        OrderService.shared.getOrder(id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let order):
                self_.setup(order)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    fileprivate func cancelOrder() {
        guard let id = orderId else { return }
        guard !loadingData else { return }
        loadingData = true
        SVProgressHUD.show()
        
        OrderService.shared.getOrder(id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let order):
                self_.setup(order)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    fileprivate func completeOrder() {
        guard let id = orderId else { return }
        guard !loadingData else { return }
        loadingData = true
        SVProgressHUD.show()
        
        OrderService.shared.getOrder(id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let order):
                // TODO do something
                break
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}
