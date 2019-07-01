//
//  Login.swift
//  LoginRegister
//
//  Created by Hasan Tahir on 09/03/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//

import UIKit
import Firebase
import CountryPickerView


class LoginVC: AppBaseVC {
    
var ref:DatabaseReference!
    
    @IBOutlet weak var passTF: UITextField!
   
    @IBOutlet weak var emailTF: UITextField!
    
    var cpv : CountryPickerView?
    var custom_height=UIScreen.main.bounds.height*(50/1024)
    override func viewDidLoad() {
        super.viewDidLoad()
        ref=Database.database().reference()

        cpv=CountryPickerView(frame:CGRect(x: 0, y: 0, width: custom_height * 2.75, height: custom_height))
        emailTF.leftView = cpv
        emailTF.leftViewMode = .always
        
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            cpv?.font = UIFont(name: (cpv?.font.fontName)!, size: 26)!
        }
        else{
            cpv?.font = UIFont(name: (cpv?.font.fontName)!, size: 22)!
        }
    }

   
    @IBAction func Login_btn(_ sender: Any) {
        ref.child("PhoneNumbers").child("\( cpv!.selectedCountry.phoneCode)\(emailTF.text ?? "")").observe(.value) {[weak self] (snapshot) in
            if let _ = snapshot.value as? String{
                 AuthenticationHandler.sharedInstance.sendverificationcode(PhoneNum: "\( self!.cpv!.selectedCountry.phoneCode)\(self!.emailTF.text ?? "")")
                let vc = VerificationVC()
                self!.navigationController?.pushViewController(vc, animated: true)
            }
            
            
    
        }
    }
    
    @IBAction func openSignUpVC(_ sender: Any) {
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
