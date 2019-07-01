//
//  RoundButton.swift
//  EmergencyApp
//
//  Created by Hasan on 30/03/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        // Common logic goes here
        
        refreshCorner(value:cornerRadius)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            if UIDevice.init().userInterfaceIdiom == UIUserInterfaceIdiom.pad{
                self.cornerRadius*=1.5
            }
            refreshCorner(value: cornerRadius)
        }
    }
    
    
    func refreshCorner (value : CGFloat){
        layer.cornerRadius=value
        
    }
}

