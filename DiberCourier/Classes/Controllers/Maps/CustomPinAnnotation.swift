//
//  CustomPinAnnotation.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/25/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit
import MapKit

class CustomPinAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var order: OrderView?
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
    }
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, order: OrderView?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.order = order
    }
    
}
