//
//  ViewControllerExtension.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import UIKit

//MARK: Alert messages for all classes to inherit
extension UIViewController{
    
    //TODO: error message
    func errorAlert(_ error:Error?,stringError:String){
        
        //create an alert controller
        let alert=UIAlertController(title: stringError, message: error?.localizedDescription ?? "", preferredStyle: .alert)
        let action=UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        //present the controller
        present(alert, animated: true, completion: nil)
    }
    
    //TODO: success message
    func successAlert(stringSuccess:String){
        
        //create an alert controller
        let alert=UIAlertController(title: "Success", message: stringSuccess, preferredStyle: .alert)
        let action=UIAlertAction(title: "OK", style: .default, handler: {(action) in
            DispatchQueue.main.async{
                self.dismiss(animated: true, completion: nil)
            }
        })
        alert.addAction(action)
        //present the controller
        present(alert, animated: true, completion: nil)
    }
}
