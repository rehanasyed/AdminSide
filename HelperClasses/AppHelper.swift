//
//  File.swift
//  EmergencyLocator
//
//  Created by Apple on 24/02/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//

import Foundation
import MBProgressHUD
class AppHelper : NSObject{

    var hud : MBProgressHUD!
    var userDetailsDic : [String:String]!
    
    private static var _obj : AppHelper? = nil
    
    class var sharedInstance:AppHelper{
        get{
            if _obj == nil{
                _obj = AppHelper()
            }
            let lockQueue = DispatchQueue(label: "_obj")
            return lockQueue.sync{
                return _obj!
            }
        }
    }
  
    var baseNavigationController:UINavigationController? {
        get{
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return nil}
            return appDelegate.navigationController
        }
    }
    
    var currentVC : UIViewController?{
        
        guard let nav = self.baseNavigationController else{return nil}
        guard let vc = nav.viewControllers.last else{return nil}
        return vc
    }
  
    
    func convertImageIntoBase64(Image image : UIImage) -> String? {
        
        guard let imageData = image.pngData() else{return nil}
        let base64Str = imageData.base64EncodedString()
        return base64Str
    }
    
    func convertBase64IntoImage(Base64 str : String) -> UIImage?{
        
        guard let imageData = Data(base64Encoded: str) else {return nil}
        guard let image = UIImage(data: imageData) else{return nil}
        return image
    }
    
    func ApplyHuffManCompressionAlgo(PlainText text : String) -> String{
        
        return ""
    }
    
    
}
