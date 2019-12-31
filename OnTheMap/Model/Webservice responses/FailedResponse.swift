//
//  FailedResponse.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation

//struct to handle responses when api fails
//this struct conforms to LocalizedError so we can pass it as an error
struct FailedResponse:Codable,LocalizedError{
    let status:Int
    let error:String
    
    //allows us to return the error property as a localizedDescription
    var errorDescription: String?{
        return error
    }
}
