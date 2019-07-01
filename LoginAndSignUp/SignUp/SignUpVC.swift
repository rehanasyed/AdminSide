//
//  Signup.swift
//  LoginRegister
//
//  Created by Hasan Tahir on 12/03/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//

import UIKit
import CountryPickerView
import FirebaseAuth
class SignUpVC: AppBaseVC {
  
    @IBOutlet weak var cpvTF: UITextField!
    
    @IBOutlet weak var tfUsername: TJTextField!
    
    @IBOutlet weak var tfPhoneNumber: UITextField!
    
    var cpv : CountryPickerView?
    
    @IBOutlet weak var tfPassword: TJTextField!
    
    @IBOutlet weak var tfConfirmPassword: TJTextField!
    
    @IBOutlet weak var tfGender: TJTextField!
    
    let genderPickerView = UIPickerView()
    
    var custom_height=UIScreen.main.bounds.height*(50/1024)
    
    let genders = ["Male","Female","Other"]
    var tfArr = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
    cpv=CountryPickerView(frame:CGRect(x: 0, y: 0, width: custom_height * 2.75, height: custom_height))
        
        if UIDevice.init().userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            cpv?.font = UIFont(name: cpv!.font.fontName, size: 26)!
        }
        
        cpvTF.leftView=cpv!
        
        cpvTF.leftViewMode = .always
        
        tfGender.inputView = genderPickerView
        tfGender.delegate = self
        
        genderPickerView.selectRow(0, inComponent: 0, animated: false)
        
        tfArr = [tfUsername,tfPhoneNumber,tfGender]
        
        }

    
    @IBAction func Signup_btn(_ sender: Any) {
       
        if let error = validationError(){
            showAlert(Title: "Error", Message: error)
        }
        else{
            AuthenticationHandler.sharedInstance.sendverificationcode(PhoneNum: "\( cpv!.selectedCountry.phoneCode)\(cpvTF.text ?? "")")
            
            let userDetails = ["PhoneNumber": "\( cpv!.selectedCountry.phoneCode)\(cpvTF.text ?? "")","Username":tfUsername.text!,"Gender":tfGender.text!]
            
            AppHelper.sharedInstance.userDetailsDic = userDetails
            
            let vc = VerificationVC()
            vc.shouldCreateUser = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func openLoginVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validationError()-> String?{
        for tf in tfArr{
            if tf.text?.count == 0{
                return "Please fill out all the fields "
            }
        }
        
//        if tfPassword.text != tfConfirmPassword.text{
//            return "Password do not Match"
//        }
        
        return nil
    }
    
}
extension SignUpVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return genders [row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfGender.text = genders[row]
        tfGender.resignFirstResponder()
    }
    
}
extension SignUpVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "Male"
    }
}
