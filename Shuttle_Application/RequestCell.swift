//
//  RequestCell.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 3/26/16.
//
//

import Foundation
import UIKit

class RequestCell: UITableViewCell {
    struct Constants {
        static let padding:CGFloat = 5.0
        
    }
    
    var addressLabel: UILabel!
    var locationLabel: UILabel!
    
    var request: Request? {
        didSet {
            if let r = request {
                addressLabel.text = r.address
                addressLabel.backgroundColor = UIColor.lightGrayColor()
                locationLabel.text = "(\(r.location.latitude), \(r.location.longitude))"
                locationLabel.backgroundColor = UIColor.grayColor()
            }
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        addressLabel = UILabel(frame: CGRectZero)
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .Center
        contentView.addSubview(addressLabel)
        locationLabel = UILabel(frame: CGRectZero)
        locationLabel.numberOfLines = 0
        locationLabel.textAlignment = .Center
        contentView.addSubview(locationLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        locationLabel.frame = CGRect(x: frame.width - 100, y: Constants.padding, width: 100, height: frame.height - 2 * Constants.padding)
        addressLabel.frame = CGRect(x: 0, y: 0, width: frame.width - locationLabel.frame.width, height: frame.height)
        
    }
}