//
//  ViewController.swift
//  HlaCaptain
//
//  Created by IT-aswaqqnet on 12/28/17.
//  Copyright © 2017 Aswaqqnet.com. All rights reserved.
//

import UIKit
import GooglePlaces

import GoogleMaps
import Firebase

import FirebaseDatabase
import FirebaseAuth

import GeoFire

import AVFoundation
import AudioToolbox
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 12.5
    var userLocation = CLLocationCoordinate2D()
    
    //var placesClient: GMSPlacesClient!
    //var locationManager = CLLocationManager()
    //var userLocation = CLLocationCoordinate2D()
    var refval: DatabaseReference!
    var refval1: DatabaseReference!
    var geofireRef: DatabaseReference!
    var geofireRef1: DatabaseReference!
    
    @IBAction func notif(_ sender: UIBarButtonItem) {
        
        
        
        
    }
    
    
    
    func displayAlert(title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    @IBOutlet weak var mapView1: GMSMapView!
    
    @IBOutlet weak var drivOnOff: UISwitch!
    
    @IBAction func driverStatusButton(_ sender: UISwitch) {
    
        if(sender.isOn == true)
        {
            print("ON")
            
            print("geo1 button pressed!")
            
            let key = Auth.auth().currentUser?.uid
            
            let rideRequestDictionary:[String:Any] = ["CarType":"Delux"]
            
            self.refval1.child(key!).setValue(rideRequestDictionary)
            
            
            
            let geoFire = GeoFire(firebaseRef: geofireRef)
            let uid = Auth.auth().currentUser?.uid
            
            geoFire?.setLocation(CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude), forKey: uid) { (error) in
                if (error != nil) {
                    print("An error occured: \(String(describing: error))")
                } else {
                    print("Saved location successfully!")
                }
            }
            childChangeObserver()
        }
        else
        {
            print("OFF")
        }
    
    }
    
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        drivOnOff.setOn(false, animated: true)
        
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: mapView1.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        
        
        // Add the map to the view, hide it until we've got a location update.
        mapView1.addSubview(mapView)
        mapView.isHidden = true
        
        refval = Database.database().reference().child("RideRequests")
        
        refval1 = Database.database().reference().child("DriverReady")
        
        geofireRef = Database.database().reference().child("DriverLoc")
        
        geofireRef1 = Database.database().reference().child("DriverDet")
        
    }
    
    func User(username: String) -> String {
        return username
    }
    
    func childChangeObserver()
    {
        print("Observer invocked")
        let key = Auth.auth().currentUser?.uid
        
        self.refval1.child(key!).observe(.childAdded) { (snapshort) in
            
            
            if(snapshort.key == "CarType")
            {
                self.displayAlert(title: "Status", message: "Ready")
                print("ADDED")
            }
            else
            {
                print(snapshort)
                
                let username = snapshort.value
                
                let user = self.User(username: username as! String)
                
                //self.displayAlert(title: "Customer Request", message: "Pic Up Customer")
                
                self.createAlert(title: "Customer Request", message: user)
                
                AudioServicesPlayAlertSound(SystemSoundID(1021))
                
            }
        }
        /*
        self.refval1.child(key!).observe(.childChanged) { (snapshort) in
            
            self.displayAlert(title: "Change", message: "Child Changed")
            print("Changed")
        }
        
        self.refval1.child(key!).observe(.childRemoved) { (snapshort) in
            
            self.displayAlert(title: "Removed", message: "Child Removed")
            print("Removed")
        }
        */
    }
    
   
    
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        userLocation = center
    
        
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let uid = Auth.auth().currentUser?.uid
        
        geoFire?.setLocation(CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude), forKey: uid) { (error) in
            if (error != nil) {
                print("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }
        
        
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func createAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: "Pic Up Customer id: "+message, preferredStyle: UIAlertControllerStyle.alert)
        
        //CREATING ON BUTTON
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            
            print ("Accept")
            print("Acc id")
            print(message)
            self.clintIDSend = message
            
            self.sendDataToNext()
            
            //
            
            
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendDataToNext()
    {
        performSegue(withIdentifier: "segueNow", sender: self)
    }
    
    var clintIDSend = ""

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if(segue.identifier == "segueNow")
        {
            
            let secondController = segue.destination as! RoutmainViewController
            
            //secondController.getDataF = userLocation
            
            //new
            
            secondController.clintReqID = clintIDSend
            
            print("center:")
            print(mapView.camera.target)
            
            print("User Loc:")
            print(userLocation)
            
        }
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

