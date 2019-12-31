//
//  StudentMapView.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import UIKit
import MapKit

class StudentMapView: UIViewController ,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - view mthods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate=self
        
    }
    
    //TODO: - populate the map with annotations when the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        StudentServices.getStudents(completionHandler: {(result,error) in
            if !result.isEmpty{
                StudentData.list=result
                //add the annotations to the map
                self.addAnnotions(StudentData.list)
                
            }else{
                self.errorAlert(error,stringError:"Unable to fetch other students")
            }
        })
    }
    
    //MARK: - NAVIGATION
    
    //TODO: - go to AddPinViewController
    @IBAction func goToPinAddition(_ sender: UIBarButtonItem) {
        
        //perform segue
        performSegue(withIdentifier: "addPin", sender: nil)
    }
    
    //MARK:- logout
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        //call the delete request to logout
        StudentServices.logout(completionHandler: {(success,error) in
            
            //if the success was true ,we were able to perform the delete request
            if success{
               
                //set the object id back to nil
                LocationData.locationId=nil
                self.dismiss(animated: true, completion: {() in
                print("Session id: \(StudentServices.Authorization.sessionId)")
                print("Uinique id: \(StudentServices.Authorization.accountKey)")
                print("loggin out")
                    
                })
            }else{
                self.errorAlert(error,stringError:"Unable to logout")
            }
        })
    }
}

//MARK: - MAPVIEW METHODS

extension StudentMapView{
    
    
    //MARK: - ANNOTATIONS
    
    
    //TODO: - create custom annotation
    //This gets executed evrytime a new annotation is created
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        //create a resuable annotation for the specified identifier
        var customAnnotationView=mapView.dequeueReusableAnnotationView(withIdentifier: "studentAnnotation") as? MKMarkerAnnotationView

        //the first time this runs the annotationView is not set up for the annotation with the specififed identifier so we have to check for that
        //if it is nil we create our annotation view
        if customAnnotationView==nil{
            //initialize and return an new marker annotation view
            customAnnotationView=MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "studentAnnotation")

            //allows for the callout bubble to pop up
            customAnnotationView?.canShowCallout=true
            
            //change the color of the marker
            customAnnotationView?.markerTintColor=UIColor.orange
       
            //add a detail disclosure button to the call out
            customAnnotationView?.rightCalloutAccessoryView=UIButton(type: .detailDisclosure)
            
        }else{//if the annotation view has been already created
            //set custom annotation view to the annotation object passed to the function
            customAnnotationView?.annotation=annotation
        }

        //return the annotation
        return customAnnotationView
    }


    
    //TODO: - Add annotation to map
    func addAnnotions(_  students:[Student]){
        
        //create an empty array of annotations
        var annotations=[MKAnnotation]()
        
        //loop through the students array
        for student in students{
            
            //create and initialize a point annotation
            //A concrete annotation object tied to the specified point on the map.
            let annotation=MKPointAnnotation()
            
            //set the coordinates of the annotation
            annotation.coordinate=CLLocationCoordinate2D(latitude: CLLocationDegrees(student.latitude), longitude: CLLocationDegrees(student.longitude))
            
            //set the title and subtitle
            annotation.title=student.firstName+" "+student.lastName
            annotation.subtitle=student.mediaURL
        
            //add to the array
            annotations.append(annotation)
        }
        
        //display the annotations on the map
        mapView.addAnnotations(annotations)
    }
    
    
    //TODO: - callout tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //if a callout is tapped open the specified url for that student/annotation on the map
        if let url=URL(string: (view.annotation?.subtitle!)!){
            //Use the singleton app instance with the open() function to open the link to the specific website from the students media url
            UIApplication.shared.open(url, completionHandler: {(success) in
                if success{
                    print("The URL was delivered successfully")
                }else{
                    DispatchQueue.main.async{
                        self.errorAlert(StudentServices.Errors.urlError,stringError:"the url was not delivered successfully")
                    }
                }
            })
        }else{
            DispatchQueue.main.async{
                self.errorAlert(StudentServices.Errors.urlError,stringError: "Unable to unwrap optional url")
            }
        }
        
    }
}
