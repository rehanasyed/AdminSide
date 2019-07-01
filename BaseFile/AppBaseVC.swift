
//
//  AppBaseVC.swift
//  EmergencyApp
//
//  Created by Hasan on 23/03/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//

import UIKit
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
