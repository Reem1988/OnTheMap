//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class AddPinViewController: UIViewController{
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    
    //MARK: - view methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationTextField.delegate=self
        locationTextField.clearButtonMode = .whileEditing
        urlTextField.delegate=self
        urlTextField.clearButtonMode = .whileEditing
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //add observers
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard),name:UIResponder.keyboardDidShowNotification ,object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name:UIResponder.keyboardDidHideNotification,object:nil)
    }
    //TODO: - methods for keyboard notifications
    @objc func showKeyboard(_ notification:Notification){
        
        //A Notification is container for information broadcast through a notification center to all registered observers.
        //.userInfo is Storage for values or objects related to this notification
        let info=notification.userInfo
        //get the keyboard frame from the .userInfo storage
        let keyboardSize=info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        //if the urlTextField is the one editing and phone is in landscape move the y value of the view up from 0 to negative the size of the keyboard
        if urlTextField.isEditing && UIDevice.current.orientation.isLandscape{
            self.view.frame.origin.y = -(keyboardSize.cgRectValue.height)
        }
    }
    
    @objc func hideKeyboard(_ notification:Notification){
        
        //if the view fram y is less tahn zero set it back to zero
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y=0
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //dismis notification
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    //MARK: - Get location
    @IBAction func findLocation(_ sender: UIButton) {
        print("button tapped")
        //Make sure all fields are entered before finding the location
        if locationTextField.text!.isEmpty || urlTextField.text!.isEmpty{
            errorAlert(nil, stringError: "Please fill out both text fields")
            return
        }
        getLocation(location: locationTextField.text!)
    }
    
    //TODO: - retrieve location based on user input
    func getLocation(location searchTerm:String){
        
        
        //show the activity
        showActivity(inProgress: true)
        
        //create a geoCoder
        let geoCoder=CLGeocoder()
        
        //geocode the user entered string
        geoCoder.geocodeAddressString(searchTerm, completionHandler: {(placemarks,error) in
            
            //there should be an array of placemarks if the geocode was successful and we try to get the first element
            guard let placemark=placemarks?.first else{
                
                DispatchQueue.main.async{
                    //if place mark is nil we dismis the activity
                    self.showActivity(inProgress: false)
                    //if placemarks is nil that means there was an error and we show an alert
                    self.errorAlert(error,stringError:"Unable to find location")
                }
                return
            }
            
            DispatchQueue.main.async{
                //if place mark is not nil nil we dismis the activity before segue
                self.showActivity(inProgress: false)
                //send the first placemark from the array through the segue
                self.performSegue(withIdentifier: "showPin", sender: placemark)
            }
        })
    }
    
    //TODO: -  cancel the pin
    @IBAction func cancelPinAddition(_ sender: UIBarButtonItem) {
        //dismis controller
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier=="showPin"{
            //convert the sender into a CLPlaceMark
            guard let placemark=sender as? CLPlacemark else{
                print("unable to retrive placemark")
                return
            }
            
            let showPinViewController=segue.destination as! ShowPinViewController
            showPinViewController.placeMark=placemark
            showPinViewController.mediaURL=urlTextField.text!
        }
    }
    
    //MARK: activity indicator set up
    func showActivity(inProgress:Bool){
        
        //show or dismiss activity
        if inProgress{
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
        
        //enable or diable the find location button
        findLocationButton.isEnabled = !inProgress
    }
}

//MARK: text field delegate methods

extension AddPinViewController:UITextFieldDelegate{
    
    //TODO: - dismiss text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //dismiss the keyboard from being the first responder
        textField.resignFirstResponder()
        
        return true
    }
}
