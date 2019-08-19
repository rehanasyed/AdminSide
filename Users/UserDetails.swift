//
//  UserDetails.swift
//  AdminSide
//
//  Created by Rehana Syed on 19/08/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class UserDetails: UIView {

    class func Init ()->UserDetails{
        let view  = Bundle.main.loadNibNamed("ActionView", owner: self, options: nil)?.first as! UserDetails
        view.layer.cornerRadius = 8
       
        return view
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
