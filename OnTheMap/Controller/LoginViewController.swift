//
//  ViewController.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    //MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set the text fields delegates
        emailTextField.delegate=self
        emailTextField.clearButtonMode = .whileEditing
        passwordTextField.delegate=self
        passwordTextField.clearButtonMode = .whileEditing
        
        
    }

    
    //TODO: - subsribe to keyboard notifications

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        //Add an observer to the applications default notification center(A notification dispatch mechanism that enables the broadcast of information to registered observers) when the keyboard shows
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyBoard(_ :)), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        //add an observer for the keyboard dismissing
        NotificationCenter.default.addObserver(self,selector: #selector(hideKeyboard(_ : )),name:UIResponder.keyboardWillHideNotification,object:nil)
    }
    
    //TODO: - unsubsribe to keyboard notification
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //remove the observers for the keyboard hiding and showing from the notification center
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //TODO: - methods for keyboard notifications
    @objc func showKeyBoard(_ notification:Notification){
        
        //A Notification is container for information broadcast through a notification center to all registered observers.
        //.userInfo is Storage for values or objects related to this notification
        let info=notification.userInfo
        //get the keyboard frame from the .userInfo storage
        let keyboardSize=info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        //if the passwordTextField is the one editing and phone is in landscape move the y value of the view up from 0 to negative the size of the keyboard
        if passwordTextField.isEditing && UIDevice.current.orientation.isLandscape{
            self.view.frame.origin.y = -(keyboardSize.cgRectValue.height)
        }
    }
    
    @objc func hideKeyboard(_ notification:Notification){
        
        //if the view fram y is less tahn zero set it back to zero
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y=0
        }
    }
    
    
    //MARK: - Handle login and signup
    
    //TODO: - link to udacity page for user to sign up
    @IBAction func signUp(_ sender: UIButton){
        
        //get the shared app isntance
        UIApplication.shared.open(URL(string:"https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!, completionHandler: {(success) in
            if success{
                print("Able to open url")
            }else{
                print("unable to open url")
            }
        })
    }
    
    //TODO: - login user on button tap
    @IBAction func login(_ sender: UIButton) {
        
        StudentServices.loginStudent(username: emailTextField.text!, password: passwordTextField.text!, completionHandler: {(response,error) in
            if response{
                self.performSegue(withIdentifier: "login", sender: nil)
            }else{
                self.errorAlert(error, stringError: "Unable to login")
            }
        })
    }
    
    //TODO: clear textfields after user successful sign in
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="login"{
            emailTextField.text=""
          passwordTextField.text=""
        }
    }
}

//MARK: - Text field delegates

extension LoginViewController:UITextFieldDelegate{
    
    //tells the delegate the return button was pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //dismiss the keyboard from being the first responder
        textField.resignFirstResponder()
        
        return true
    }
    
}

