//
//  Student.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation

//MARK: - Student codable struct
struct Student:Codable{
    
    //TODO: - api key value pair mapped
    let firstName:String
    let lastName:String
    let longitude:Float
    let latitude:Float
    let mapString:String
    let mediaURL:String
    let objectId:String
    let uniqueKey:String

    
    
}
