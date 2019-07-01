//
//  FirebaseAuthenticationHandler.swift
//  EmergencyLocator
//
//  Created by Apple on 06/03/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationHandler{
    
    private static var _obj : AuthenticationHandler? = nil
    
    class var sharedInstance:AuthenticationHandler{
        get{
            if _obj == nil{
                _obj = AuthenticationHandler()
            }
            let lockQueue = DispatchQueue(label: "_obj")
            return lockQueue.sync{
                return _obj!
            }
        }
    }
    
    func userVerification(verificationCode: String , completionHandler : ((_ result : Bool) -> Void)?) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (Data, error) in
            if error == nil{
                
            }
        })
        
        completionHandler!(true)
        
    }
    
    func sendverificationcode(PhoneNum:String){
        PhoneAuthProvider.provider().verifyPhoneNumber(PhoneNum, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // Sign in using the verificationID and the code sent to the user
            // ...
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            UserDefaults.standard.synchronize()
            
        }
        
    }
    
    func registerUser(firstName:String,lastName:String,gender:String,email:String,password:String, userCreationComplete: @escaping (_ status: Bool, _ error:Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, errorInCreation) in
            guard let user = user else {
                userCreationComplete(false,errorInCreation)
                return
            }
            let userData = ["provider":user.user.providerID , "email":user.user.email, "firstName":firstName , "lastName":lastName , "gender":gender , "password":password]
            
          
//            DataService.instance.createDBUser(uid: user.user.uid, UserData: userData as [String : Any])
//            userCreationComplete(true,nil)
            
        }
    }
}
