//
//  EmergencyScreenVC.swift
//  AdminSide
//
//  Created by Hasan on 06/08/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseDatabase
import FirebaseAuth

class EmergencyScreenVC: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    
    var currentLocationMarker : GMSMarker = GMSMarker()
    var userLocationMarker : GMSMarker = GMSMarker()
    var currentLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var userLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    let KarachiLocation =  CLLocation(latitude: 24.8607, longitude: 67.0011)
    var selectedLocation : CLLocationCoordinate2D!
    
    var currentZoomLevel : Float = 15.0
    var currentType = "Reports"
    var ref : DatabaseReference! = nil
    var shouldAdjustCamera : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        if Session.sharedInstance.userLocationNode == ""
        {
            return
        }
        
        startSOSTracking()
    }
    
    func startSOSTracking(){
        self.addUserLocationMarker(Type: self.currentType)
        
        LocationHelper.sharedInstance.getCurrentLocation = {[weak self](location) in
        self!.ref.child("InDanger").child(Session.sharedInstance.userLocationNode!).observe(.value) { (snapshot) in
                guard let locationDic = snapshot.value as? [String:CLLocationDegrees] else{return}
                self?.userLocation = CLLocationCoordinate2D(latitude: locationDic["Lat"]!, longitude: locationDic["Long"]!)
                self!.currentLocation = location.coordinate
                self!.selectedLocation = self!.KarachiLocation.coordinate
                GoogleMapsManager.sharedInstance.getDirections(Origin: self!.currentLocation , Destination: self!.userLocation) { [weak self](routes) in
                    DispatchQueue.main.async {
                        self!.addCurrentLocationMarker()
                        self!.AdjustCamera()
                        GoogleMapsManager.sharedInstance.drawPolyLineOnMap(Routes: routes, Map: self!.mapView)
                    
                        }
                    }
                }
            }
        
    }

}

extension EmergencyScreenVC{
    
    func addMarkersInMap(Location location : CLLocationCoordinate2D, Type imageName : String){
        let marker = GMSMarker(position: location)
        marker.map = self.mapView
        marker.icon = GoogleMapsManager.sharedInstance.setMarkerImage(image: UIImage(named: imageName)!, scaledToSize: CGSize(width: 50, height: 50))
        
    }
    
    func addCurrentLocationMarker(){
        currentLocationMarker.position = CLLocationCoordinate2D(latitude: KarachiLocation.coordinate.latitude, longitude: KarachiLocation.coordinate.longitude)
        currentLocationMarker.appearAnimation = .pop
        currentLocationMarker.map = self.mapView
    }
    
    func addUserLocationMarker(Type type : String){
        userLocationMarker.icon = GoogleMapsManager.sharedInstance.setMarkerImage(image: UIImage(named: type)!, scaledToSize: CGSize(width: 50, height: 50))
        userLocationMarker.map = self.mapView
    }
    
    
    func adjustZoom (Radius rad : Float){
        self.currentZoomLevel = 14.5 - (rad/7500)
        self.mapView.camera = GMSCameraPosition.camera(withTarget: KarachiLocation.coordinate, zoom: self.currentZoomLevel)
    }
    
    func AdjustCamera(){
        if shouldAdjustCamera{
            self.mapView.camera = GMSCameraPosition.camera(withTarget: selectedLocation, zoom: 15)
            shouldAdjustCamera = false
        }
        
    }
    
}

extension EmergencyScreenVC : GMSMapViewDelegate{

}
