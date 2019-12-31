//
//  ShowPinViewController.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import UIKit
import MapKit

class ShowPinViewController: UIViewController,MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    //optionals proeprties to retirve data via segue
    var placeMark:CLPlacemark?
    var mediaURL:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate=self
        // Do any additional setup after loading the view.
        print(placeMark!)
        print(mediaURL!)
        
        addAnnotation()
    }
    
    
    func addAnnotation(){
        
        //Post the annotation on the map
        if let placeMark=placeMark{
            let annotation=MKPointAnnotation()
            annotation.coordinate=placeMark.location!.coordinate
            annotation.title=placeMark.name!
            mapView.addAnnotation(annotation)
        
        //zoom into the annotation
        let region=MKCoordinateRegion(center: placeMark.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        mapView.setRegion(region, animated: true)
        }
    }
    
    //TODO: - add the pin
    @IBAction func addPin(_ sender: UIButton) {
        
        //get the student based on the id first to access its information
        StudentServices.getStudenyByID(completionHandler: {(response,error) in
            if let response=response{
                self.postOrPutLocation(studentById:response)
            }else{
                self.errorAlert(error,stringError:"Unable to get user information")
            }
        })
    }
    
    //After we get use information we then are able to post or put the pin
    func postOrPutLocation(studentById:StudentByID){
        
        //if the locationId is nil that means we have not posted a location and call the post location instead of put
        if let locationId = LocationData.locationId{
            StudentServices.putLocation(studentById, mediaURL!, locationName: placeMark!.name!, longitude: placeMark!.location!.coordinate.longitude, latitude: placeMark!.location!.coordinate.latitude, objectId: locationId, completionHandler: {(response,error) in
                
                if let _ = response{
                    self.successAlert(stringSuccess: "Student location Updated.")
                    
                }else{
                    self.errorAlert(error, stringError: "Unable to post location")
                }
            })
        }else{
            StudentServices.postLocation(studentById, mediaURL!, locationName: placeMark!.name!, longitude: placeMark!.location!.coordinate.longitude, latitude: placeMark!.location!.coordinate.latitude, completionHandler: {(response,error) in
                
                if let response=response{
                    LocationData.locationId=response.objectId
                    self.successAlert(stringSuccess: "Student location Posted.")
                }else{
                    self.errorAlert(error, stringError: "Unable to post location")
                }
            })
        }
    }
    
    //TODO: - cancel the pin
    @IBAction func cancelPinAddition(_ sender: UIBarButtonItem) {
        //dismiss the entire navigation controller heirachy that was presented modally
        dismiss(animated: true, completion: nil)
    }
}
