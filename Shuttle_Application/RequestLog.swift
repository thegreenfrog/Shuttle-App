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

class Request {
    var address: String
    var location: CLLocationCoordinate2D
    var name: String
    var partySize: Int
    
    init(addr: String, loc: CLLocationCoordinate2D, n: String, p: Int) {
        address = addr
        location = loc
        name = n
        partySize = p
    }
}

//class RequestLog {
//    var requests: [Request] = []
//    
//    func moreRequests(num: Int) -> Bool {
//        return requests.count != num
//    }
//    
//    func getAllRequests() -> ([String], [CLLocationCoordinate2D]) {
//        var names = [String]()
//        var locs = [CLLocationCoordinate2D]()
//        for request in requests {
//            names.append(request.address)
//            locs.append(request.location)
//        }
//        return (names, locs)
//    }
//    
//    func addRequest(req: Request) {
//        requests.append(req)
//    }
//}
//
//class RequestTabBarController: UITabBarController {
//    let request = RequestLog()
//}