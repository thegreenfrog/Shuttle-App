//
//  StopRequest.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 2/28/16.
//
//

import Foundation
import MapKit


class StopRequest: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
