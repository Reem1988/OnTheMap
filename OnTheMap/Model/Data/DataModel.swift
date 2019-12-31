//
//  StudentDataList.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation


class StudentData{
    //static variable to hold the list of students
    static var list=[Student]()
    
}

class LocationData{
    //static variable to hold the location id to make sure user can only post one per login
    //if user already post then he can update
    static var locationId:String?
    
}
