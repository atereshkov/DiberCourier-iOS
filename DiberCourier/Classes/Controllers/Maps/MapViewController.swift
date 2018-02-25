//
//  MapViewController.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/25/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pointDetailLabel: UILabel!
    @IBOutlet weak var pointDetailView: UIView!
    
    fileprivate var selectedPoint: CustomPinAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInitialPosition()
    }
    
    deinit {
        LogManager.log.info("Deinit")
    }
    
    // MARK: Private
    
    private func setupMap(items: [OrderView]) {
//        for item in items {
//            let annotation = CustomPinAnnotation()
//            guard let lat = item.location?.lat, let lon = item.location?.lon else {
//                LogManager.log.info("Error during parsing of lon/lat")
//                continue
//            }
//            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//            annotation.title = item.title
//            annotation.order = item
//            mapView.addAnnotation(annotation)
//        }
    }
    
    private func setupInitialPosition() {
        let span = MKCoordinateSpanMake(22, 22) // Zoom level
        let lat = 53.0891117
        let long = 28.341105
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        mapView.setRegion(region, animated: true)
    }
    
    /*
    fileprivate func selectAnnotation(item: OrderView) {
        let annotations = mapView.annotations.flatMap({ $0 as? CustomPinAnnotation })
        guard let selectedAnnotation = annotations.filter({ $0.order?.id == item.id }).first else { return }
        self.mapView.selectAnnotation(selectedAnnotation, animated: true)
        self.mapView.region.center = selectedAnnotation.coordinate
        self.showPointDetailView(for: item)
    }
    */
    
    fileprivate func showPointDetailView(for item: OrderView) {
        self.pointDetailLabel.text = "\(item.id)"
        // Show point detail view if needed
        if self.pointDetailView.alpha != 1 {
            self.pointDetailView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.pointDetailView.alpha = 1
            }, completion:  nil)
        }
    }
    
    fileprivate func hidePointDetailView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.pointDetailView.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.pointDetailView.isHidden = false
        })
    }
    
    // MARK: Actions
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomPinAnnotation, let item = annotation.order {
            self.showPointDetailView(for: item)
        }
        
        guard let annotation = view.annotation as? CustomPinAnnotation else { return }
        self.selectedPoint = annotation
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.hidePointDetailView()
        self.selectedPoint = nil
    }
    
}
