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

class EmergencyScreenVC: AppBaseVC {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var bottomArrowBtn: UIButton!
    
    @IBOutlet weak var bottomConstraintArrowBtn: NSLayoutConstraint!
    var userDetails = UserDetails.Init()
    
    var currentLocationMarker : GMSMarker = GMSMarker()
    var userLocationMarker : GMSMarker = GMSMarker()
    var currentLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var userLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    let KarachiLocation =  CLLocation(latitude: 24.8607, longitude: 67.0011)
    var selectedLocation : CLLocationCoordinate2D!
    
    var currentZoomLevel : Float = 15.0
    var currentType = "help"
    var ref : DatabaseReference! = nil
    var shouldAdjustCamera : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        startSOSTracking()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        userDetails.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - view.layoutMargins.bottom, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
        view.addSubview(userDetails)
    }
    
    func startSOSTracking(){
        
        guard let userID = Session.sharedInstance.userLocationNode else
        {
            return
        }
        
        DatabaseHandler.sharedInstance.getUserData(uid: userID) { [weak self] (userDic) in
            if let user = self!.convertDicIntoUser(UserDictionary: userDic){
                Session.sharedInstance.emergencyUser = user
                self!.userDetails.bindData()
            }
        }
        
        LocationHelper.sharedInstance.getCurrentLocation = {[weak self](location) in
            self!.ref.child("InDanger").child(Session.sharedInstance.userLocationNode!).observe(.value) { (snapshot) in
                guard let locationDic = snapshot.value as? [String:CLLocationDegrees] else{return}
                self?.userLocation = CLLocationCoordinate2D(latitude: locationDic["Lat"]!, longitude: locationDic["Long"]!)
                self!.currentLocation = location.coordinate
                self!.selectedLocation = self!.KarachiLocation.coordinate
                //self!.selectedLocation = self!.currentLocation
                GoogleMapsManager.sharedInstance.getDirections(Origin: self!.selectedLocation , Destination: self!.userLocation) { [weak self](routes) in
                    DispatchQueue.main.async {
                        self!.adjustCurrentLocationMarker()
                        self!.adjustUserLocationMarker(Type: self!.currentType)
                        self!.AdjustCamera()
                        GoogleMapsManager.sharedInstance.drawPolyLineOnMap(Routes: routes, Map: self!.mapView)
                        
                    }
                }
            }
        }
        
    }
    
    func animateActionSheetUpward(){
        //if Session.sharedInstance.userLocationNode == nil {return}
        UIView.animate(withDuration: 1) {
            self.bottomConstraintArrowBtn.constant += self.userDetails.frame.height
            self.userDetails.center.y -= self.userDetails.frame.height
        }
    }
    
    func animateActionSheetDownward(){
        UIView.animate(withDuration: 1) {
            self.bottomConstraintArrowBtn.constant -= self.userDetails.frame.height
            self.userDetails.center.y += self.userDetails.frame.height
        }
    }
    
    @IBAction func terminate(_ sender: Any) {
        Session.sharedInstance.userLocationNode = nil
    }
    
    @IBAction func didTapArrowButton(_ sender: UIButton) {
        if sender.isSelected{
            animateActionSheetDownward()
            sender.isSelected = false
        }
        else{
            
            animateActionSheetUpward()
            sender.isSelected = true
        }
        
    }
    
    
}

extension EmergencyScreenVC{
    
    func addMarkersInMap(Location location : CLLocationCoordinate2D, Type imageName : String){
        let marker = GMSMarker(position: location)
        marker.map = self.mapView
        marker.icon = GoogleMapsManager.sharedInstance.setMarkerImage(image: UIImage(named: imageName)!, scaledToSize: CGSize(width: 50, height: 50))
        
    }
    
    func adjustCurrentLocationMarker(){
        currentLocationMarker.position = CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
        currentLocationMarker.appearAnimation = .pop
        currentLocationMarker.map = self.mapView
    }
    
    func adjustUserLocationMarker(Type type : String){
        userLocationMarker.position = CLLocationCoordinate2D(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
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
