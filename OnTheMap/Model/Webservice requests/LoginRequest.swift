//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation

struct LoginRequest:Codable{
    let udacity:UserInfo
}

//struct for user login
struct UserInfo:Codable{
    let username:String
    let password:String
    
    init(_ username:String,_ password:String){
        self.username=username
        self.password=password
    }
}
