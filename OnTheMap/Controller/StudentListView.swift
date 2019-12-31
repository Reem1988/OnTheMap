//
//  StudentListView.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import UIKit


class StudentListView:UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource=self
        
    }
    
    //TODO: - populate table view when load views
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //call the .getStudents() method to populate the list in DataModel
        StudentServices.getStudents(completionHandler: {(result,error) in
            
            //if the result is not empty
            if !result.isEmpty{
                StudentData.list=result
                //reload the tableView
                self.tableView.reloadData()
            }else{
                self.showAlert(error,customError:"Unable to fetch other students")
            }
            
        })
    }
    
    //TODO: - show an alert when user has invalid credentials
    func showAlert(_ error:Error?,customError:String){
        //create an alert controller
        var alert:UIAlertController
        
        //if error is not nil send the localizedDescription for the error as the message
        if let error=error{
            alert=UIAlertController(title: "Error", message:error.localizedDescription, preferredStyle: .alert)
        }else{//give a generic message
            alert=UIAlertController(title: "Error", message:customError, preferredStyle: .alert)
        }
        
        //create an action to add to the alrt controller
        let action=UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        
        //present the alert controller modally
        self.present(alert, animated: true, completion: nil)
        
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
                self.showAlert(error,customError:"Unable to logout")
            }
        })
    }
    //AMRK:Navigation
    
    //TODO: - go to AddPinViewController
    
    @IBAction func goToPinAddition(_ sender: UIBarButtonItem) {
        //perform seque
        performSegue(withIdentifier: "addPin", sender: nil)
    }
    
}

//MARK: - Tableview protocol methods

extension StudentListView:UITableViewDataSource,UITableViewDelegate{
    
    //tells the delegeate the amount of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentData.list.count
    }
    
    //TODO: - populates each cell in the row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a new reusable cell
        let cell=tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        //populate the cell
        
        //set the students full name
        cell.textLabel?.text=StudentData.list[indexPath.row].firstName+" "+StudentData.list[indexPath.row].lastName
        
        //set teh students medial url
        cell.detailTextLabel?.text=StudentData.list[indexPath.row].mediaURL
        
        //return the cell
        return cell
    }
    
    //TODO: - user row selecction
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //deselct the row
        tableView.deselectRow(at: indexPath, animated: true)
      
        //if a row is tapped open the specified url for that student
        if let url=URL(string: StudentData.list[indexPath.row].mediaURL){
            //Use the singleton app instance with the open() function to open the link to the specific website from the students media url
            UIApplication.shared.open(url, completionHandler: {(success) in
                if success{
                    print("The URL was delivered successfully")
                }else{
                    DispatchQueue.main.async{
                        self.showAlert(StudentServices.Errors.urlError,customError: "The URL was no delivery successully")
                    }
                }
            })
        }else{
            DispatchQueue.main.async{
                self.showAlert(StudentServices.Errors.urlError,customError: "Unable to open safari")
            }
        }
    }
    
    
}
