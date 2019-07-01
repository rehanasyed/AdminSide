//
//  VerificationVC.swift
//  
//
//  Created by Hasan on 02/05/2019.
//

import UIKit
import FirebaseAuth

class VerificationVC: AppBaseVC {

    @IBOutlet weak var requestcallbutton: UIButton!
    @IBOutlet weak var resendcodebutton: UIButton!
    @IBOutlet weak var NumberLabel: UILabel!
    @IBOutlet weak var timelabel2: UILabel!
    @IBOutlet weak var timelabel1: UILabel!
    @IBOutlet weak var tf1: TextFieldDesign!
    @IBOutlet weak var tf2: TextFieldDesign!
    
    @IBOutlet weak var tf4: TextFieldDesign!
    @IBOutlet weak var tf3: TextFieldDesign!
    
    @IBOutlet weak var tf6: TextFieldDesign!
    @IBOutlet weak var tf5: TextFieldDesign!
    
    var timer = Timer()
    var seconds=60
    var shouldCreateUser : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //NumberLabel.text=UserDetails.driverphonenumber
        
        timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timelabelupdate), userInfo: nil, repeats: true)
        
        tf1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tf6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChange (textField:UITextField)
    {
        let text = textField.text
        
        if text?.count == 1{
            switch textField {
            case tf1:
                tf2.becomeFirstResponder()
            case tf2:
                tf3.becomeFirstResponder()
            case tf3:
                tf4.becomeFirstResponder()
            case tf4:
                tf5.becomeFirstResponder()
            case tf5:
                tf6.becomeFirstResponder()
            case tf6:
                tf6.resignFirstResponder()
                verifyUser()
                
                
                
            default:
                break
            }
        }
    }
    
    
    func verifyUser(){
        let authCode = "\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)\(tf5.text!)\(tf6.text!)"
        AuthenticationHandler.sharedInstance.userVerification(verificationCode: authCode) { [weak self](result) in
            if result{
                if self!.shouldCreateUser{
                    DatabaseHandler.sharedInstance.createDBUser(uid: Auth.auth().currentUser!.uid, UserData: AppHelper.sharedInstance.userDetailsDic)
                    DatabaseHandler.sharedInstance.ref.child("PhoneNumbers").setValue([AppHelper.sharedInstance.userDetailsDic["PhoneNumber"]:""])
                }
                let vc = MapVC()
                self!.navigationController?.pushViewController(vc, animated: true)
            }
            
            else{
                self!.showAlert(Title: "Error", Message: "Incorrect verification code")
            }
        }
      
    }
    
    @objc func timelabelupdate(){
        var timestr = ""
        seconds-=1
        if seconds == 0{
            timer.invalidate()
            resendcodebutton.isEnabled=true
            requestcallbutton.isEnabled=true
            
        }
        if seconds<10{
            timestr="00:0\(seconds)"
            
        }
        else{
            timestr="00:\(seconds)"
            
        }
        
        timelabel1.text=timestr
        timelabel2.text=timestr
        
    }
    
    
    @IBAction func resendcode(_ sender: Any) {
        AuthenticationHandler.sharedInstance.sendverificationcode(PhoneNum: "")
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
