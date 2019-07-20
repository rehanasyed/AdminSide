//
//  UIViewExtension.swift
//  EmergencyLocator
//
//  Created by Apple on 24/02/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//

import UIKit
import MBProgressHUD
extension UIView {

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func showLoader(ShouldShow show : Bool, Text withText : String? = nil){
        var hud = AppHelper.sharedInstance.hud
        hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud!.mode = .annularDeterminate
        hud!.label.text = withText ?? "Loading"
        hud?.hide(animated: !show)
        
    }

}
