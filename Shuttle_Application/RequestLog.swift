//
//  RequestLog.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 3/10/16.
//
//

import Foundation
import CoreLocation
import UIKit

class RequestLog {
    var requests: [String: CLLocationCoordinate2D] = [:]
    
    func moreRequests(num: Int) -> Bool {
        return requests.count != num
    }
    
    func getAllRequests() -> ([String], [CLLocationCoordinate2D]) {
        var names = [String]()
        var locs = [CLLocationCoordinate2D]()
        for request in requests {
            names.append(request.0)
            locs.append(request.1)
        }
        return (names, locs)
    }
    
    func addRequest(name: String, location: CLLocationCoordinate2D) {
        requests[name] = location
    }
}

class RequestTabBarController: UITabBarController {
    let request = RequestLog()
}