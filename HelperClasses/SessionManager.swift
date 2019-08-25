//
//  SessionManager.swift
//  AdminSide
//
//  Created by MBP on 08/08/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import CoreLocation

class Session : NSObject{

    var userLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var userLocationNode : String? = nil
    var emergencyUser : EmergencyUser!
    
    private static var _obj : Session? = nil
    
    class var sharedInstance:Session{
        get{
            if _obj == nil{
                _obj = Session()
            }
            let lockQueue = DispatchQueue(label: "_obj")
            return lockQueue.sync{
                return _obj!
            }
        }
    }
    
    
}
