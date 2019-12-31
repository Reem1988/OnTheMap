//
//  StudentRequest.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation

struct StudentRequest:Codable{
    
    let firstName:String
    let lastName:String
    let uniqueKey:String
    let mediaURL:String
    let longitude:Double
    let latitude:Double
    let mapString:String
    
}
