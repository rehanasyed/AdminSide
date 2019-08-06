//
//  GooglePlacesHelper.swift
//  EmergencyLocator
//
//  Created by Hasan Tahir on 16/02/2019.
//  Copyright © 2019 Hasan Tahir. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps
//import Alamofire

class GoogleMapsManager : NSObject{
    
    private static var _obj : GoogleMapsManager? = nil
    
    class var sharedInstance:GoogleMapsManager{
        get{
            if _obj == nil{
                _obj = GoogleMapsManager()
            }
            let lockQueue = DispatchQueue(label: "_obj")
            return lockQueue.sync{
                return _obj!
            }
        }
    }
    
    var PlaceTypes : [String:String] = ["Hospital":"hospital","Police":"police","Bank":"bank","Fire Station" : "fire_station" ]
    
    func searchPlacesByType (CurrentLocation location : CLLocation , PlaceType type : String,Radius rad : Float,CompletionHandler handler : ((PlacesType)->Void)? = nil ){
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&radius=\(rad)&type=\(PlaceTypes[type]!)&key=\(AppConstant.GoogleMapApiKey)")!
     
        URLSession.shared.dataTask(with: url) { (data, res, error) in
            if let Data = data{
                let parsedData = try! JSONDecoder().decode(PlacesType.self, from: Data)
                handler!(parsedData)
            }
             else{
                //print(error?.localizedDescription)
            }
        }.resume()
        
    }
    
    func getDirections(Origin origin : CLLocationCoordinate2D , Destination destination : CLLocationCoordinate2D , CompletionHandler handler : (([Route])->Void)? = nil ){
        
        let url =  URL(string:"https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&key=\(AppConstant.GoogleMapApiKey)")!
        URLSession.shared.dataTask(with: url) { (data, res, error) in
            if let Data = data{
                guard let parsedData = try? JSONDecoder().decode(Direction.self, from: Data) else {return}
                let routes = parsedData.routes
                handler?(routes)
            }
        }.resume()

    }
    
    func drawPolyLineOnMap(Routes routes : [Route], Map map : GMSMapView){
        
        DispatchQueue.main.async {
            for route in routes{
                let routeOverviewPolyline = route.overviewPolyline
                let points = routeOverviewPolyline.points
                let path = GMSPath.init(fromEncodedPath: points)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 3
                polyline.strokeColor = UIColor.red
                polyline.map = map
            }
        }
    }
    
    func setMarkerImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

