//
//  UserDetails.swift
//  AdminSide
//
//  Created by Rehana Syed on 19/08/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class UserDetails: UIView {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    class func Init ()->UserDetails{
        let view  = Bundle.main.loadNibNamed("UserDetails", owner: self, options: nil)?.first as! UserDetails
        view.layer.cornerRadius = 8
       
        return view
    }
    
    func bindData(){
        if Session.sharedInstance.emergencyUser == nil {return}
        lblName.text = Session.sharedInstance.emergencyUser.Name
        lblPhoneNumber.text = Session.sharedInstance.emergencyUser.PhoneNumber
        
    }
    @IBAction func callUser(_ sender: Any) {
        guard let number = URL(string: "tel://" + Session.sharedInstance.emergencyUser.PhoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
