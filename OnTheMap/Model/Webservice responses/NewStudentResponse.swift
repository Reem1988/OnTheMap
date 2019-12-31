//
//  NewStudentResponse.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation

//struct for API response when adding a new student to the map
struct NewStudentResponse:Codable{
    
    let createdAt:String
    let objectId:String
    
}
