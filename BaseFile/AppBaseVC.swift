
//
//  AppBaseVC.swift
//  EmergencyApp
//
//  Created by Hasan on 23/03/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//

import UIKit
import CountryPickerView
import FirebaseAuth
import FirebaseDatabase

class AppBaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addNavBarBackButton(){
        let button = UIBarButtonItem(title: "<-", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = button
    }
    
    func showAlert (Title title : String , Message message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func convertDicIntoUser(UserDictionary : [String:Any]) -> EmergencyUser?{
        guard let name = UserDictionary["Username"] as? String else {return nil}
        guard let phoneNumber = UserDictionary["PhoneNumber"] as? String else {return nil}
        guard let gender = UserDictionary["Gender"] as? String else {return nil}
        
        return EmergencyUser(Gender: gender == "Male" ? .Male : .Female , Name: name, PhoneNumber: phoneNumber)
    }

}
