//
//  FirebaseDBHandler.swift
//  EmergencyApp
//
//  Created by Hasan on 01/05/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseHandler{
    
    private static var _obj : DatabaseHandler? = nil
    let ref = Database.database().reference()
    class var sharedInstance:DatabaseHandler{
        get{
            if _obj == nil{
                _obj = DatabaseHandler()
            }
            let lockQueue = DispatchQueue(label: "_obj")
            return lockQueue.sync{
                return _obj!
            }
        }
        
    }
    
    
    
    func createDBUser(uid:String , UserData:[String:Any]){
       ref.child("Admin").child(uid).updateChildValues(UserData)
    }
    
    func getUserData(uid:String, completionHandler : (([String:Any]) -> Void)? = nil){
        ref.child("Users").child(uid).observe(.value) { (snapshot) in
            if let userDic = snapshot.value as? [String:Any]{
                completionHandler!(userDic)
            }
        }
    }
}
