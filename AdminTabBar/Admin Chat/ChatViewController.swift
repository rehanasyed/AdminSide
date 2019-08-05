//
//  ChatViewController.swift
//  DJLight
//
//  Created by Hasan on 27/04/2019.
//  Copyright © 2019 DJ. All rights reserved.
//

import UIKit
import FirebaseAuth
//import IQKeyboardManagerSwift

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userType = AppConstant.currentAppMode == .Admin ? "Admin" : "User"
        if Auth.auth().currentUser == nil{
            let alert = UIAlertController(title: "Login Error", message: "Please Sign in to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self](Action) in
                //self!.tabBarController?.selectedIndex = 0
                self!.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let vc = ChannelsViewController(currentUser: Auth.auth().currentUser!, userType: userType)
        
        self.navigationController?.pushViewController(vc, animated: false)
        
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
