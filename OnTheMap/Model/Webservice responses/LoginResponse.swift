//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation

struct Account:Codable{
    let registered:Bool
    let key:String
}

struct Session:Codable{
    let id:String
    let expiration:String
}


struct LoginResponse:Codable{
    let account:Account
    let session:Session
}
