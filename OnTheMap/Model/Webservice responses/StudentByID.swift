//
//  StudentByID.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation

struct StudentByID:Codable{
  

//The information needed for a specific user that is returned as a response

    let lastName:String
    let firstName:String
    let key:String
    
    
    enum CodingKeys:String,CodingKey{
        case firstName="first_name"
        case lastName="last_name"
        case key
    }
}
